import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../widgets/message_bubble.dart';

class GroupChatScreen extends StatefulWidget {
  final String userName;
  final String groupId;

  GroupChatScreen({
    required this.userName,
    required this.groupId,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  final ScrollController _scrollController = ScrollController();

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
      _joinGroup();
    });

    socket.on('disconnect', (_) {
      print('disconnected from socket server');
      // Attempt to reconnect after a delay
      Future.delayed(Duration(seconds: 5), () {
        socket.connect();
      });
    });

    socket.on('receiveGroupMessage', (data) {
      print('Group message received: $data'); // Logging received messages
      setState(() {
        _messages.add({
          'sender': data['sender'],
          'message': data['message'],
        });
      });
      _scrollToBottom();
    });
  }

  void _joinGroup() {
    socket.emit('joinGroup', {
      'userName': widget.userName,
      'groupId': widget.groupId,
    });
    print('${widget.userName} joined group: ${widget.groupId}');
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

  Future<void> _sendGroupMessage() async {
    final message = _controller.text;

    final messageData = {
      'sender': widget.userName,
      'groupId': widget.groupId,
      'message': message,
    };

    socket.emit('sendGroupMessage', messageData);
    print('Group message sent: $messageData'); // Logging sent messages
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat: ${widget.groupId}'),
      ),
      body: Column(
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
                  onPressed: _sendGroupMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
