import 'package:flutter/material.dart';
import '../../services/user_services.dart';
import 'chat_screen.dart';

class SearchUserScreen extends StatefulWidget {
  final String userName;

  SearchUserScreen({required this.userName});

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _searchResult;

  void _searchUser() async {
    setState(() {
      _isLoading = true;
    });

    final userService = UserService();
    final result = await userService.searchUser(_searchController.text);

    setState(() {
      _isLoading = false;
      _searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUser,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResult != null
                ? ListTile(
              title: Text(_searchResult!['name']),
              subtitle: Text(_searchResult!['email']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userName: widget.userName,
                      chatPartnerName: _searchResult!['email'],
                      selectedLanguage: 'en', // Default language for simplicity
                    ),
                  ),
                );
              },
            )
                : Center(child: Text('No user found')),
          ],
        ),
      ),
    );
  }
}
