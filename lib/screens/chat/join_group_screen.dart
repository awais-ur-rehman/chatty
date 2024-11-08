import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class JoinGroupScreen extends StatefulWidget {
  final String userName;

  JoinGroupScreen({required this.userName});

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final TextEditingController _groupIdController = TextEditingController();
  bool _isLoading = false;

  Future<void> _joinGroup() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/groups/join-group'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'groupId': _groupIdController.text,
        'userName': widget.userName,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/groupChat', arguments: {
        'userName': widget.userName,
        'groupId': _groupIdController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join group. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _groupIdController,
              labelText: 'Group ID',
              hintText: 'Enter the group ID',
            ),
            SizedBox(height: 32.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'Join Group',
              onPressed: _joinGroup,
            ),
          ],
        ),
      ),
    );
  }
}
