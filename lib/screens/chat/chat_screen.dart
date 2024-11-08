import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:translator/translator.dart';

import '../../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String chatPartnerName;
  final String selectedLanguage;

  ChatScreen({
    required this.userName,
    required this.chatPartnerName,
    required this.selectedLanguage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  final ScrollController _scrollController = ScrollController();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io('https://chattty-76d3d7e4e578.herokuapp.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('connected to socket server');
      _joinRoom();
    });

    socket.on('disconnect', (_) {
      print('disconnected from socket server');
      // Attempt to reconnect after a delay
      Future.delayed(Duration(seconds: 5), () {
        socket.connect();
      });
    });

    socket.on('receiveMessage', (data) async {
      print('Message received: $data'); // Logging received messages
      if (data['sender'] != widget.userName) {
        String translatedMessage = await _translateMessage(data['message'], widget.selectedLanguage);
        setState(() {
          _messages.add({
            'sender': data['sender'],
            'receiver': data['receiver'],
            'message': translatedMessage,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _joinRoom() {
    final List<String> users = [widget.userName, widget.chatPartnerName];
    users.sort();
    final room = users.join("_");
    socket.emit('joinRoom', {
      'userName': widget.userName,
      'chatPartnerName': widget.chatPartnerName,
      'room': room,
    });
    print('${widget.userName} joined room: $room');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _controller.text;

    final messageData = {
      'sender': widget.userName,
      'receiver': widget.chatPartnerName,
      'message': message,
    };

    socket.emit('sendMessage', messageData);
    print('Message sent: $messageData'); // Logging sent messages
    setState(() {
      _messages.add(messageData);
    });
    _controller.clear();
    _scrollToBottom();
  }

  Future<String> _translateMessage(String text, String targetLanguage) async {
    var translation = await translator.translate(text, to: targetLanguage);
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatPartnerName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  bool isSentByMe = message['sender'] == widget.userName;

                  return MessageBubble(
                    message: message['message'],
                    isSentByMe: isSentByMe,
                    sender: message['sender'], // Pass the sender's username
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Enter message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
