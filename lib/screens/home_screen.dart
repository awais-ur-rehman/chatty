import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  HomeScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatty Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              text: 'Search Users',
              onPressed: () {
                Navigator.pushNamed(context, '/searchUser', arguments: {'userName': userName});
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Join Group',
              onPressed: () {
                Navigator.pushNamed(context, '/joinGroup', arguments: {'userName': userName});
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Create Group',
              onPressed: () {
                Navigator.pushNamed(context, '/createGroup', arguments: {'userName': userName});
              },
            ),
          ],
        ),
      ),
    );
  }
}
