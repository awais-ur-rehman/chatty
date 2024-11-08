import 'package:flutter/material.dart';
import '../../services/group_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CreateGroupScreen extends StatefulWidget {
  final String userName;

  CreateGroupScreen({required this.userName});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading = false;
  String? _groupId;

  void _createGroup() async {
    setState(() {
      _isLoading = true;
    });

    final groupService = GroupService();
    final response = await groupService.createGroup(
      widget.userName,
      _groupNameController.text,
    );

    setState(() {
      _isLoading = false;
      _groupId = response?['groupId'];
    });

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group created successfully. Group ID: $_groupId')),
      );
      print(response);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group creation failed. Please try again.')),
      );
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _groupNameController,
              labelText: 'Group Name',
              hintText: 'Enter group name',
            ),
            SizedBox(height: 32.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'Create Group',
              onPressed: _createGroup,
            ),
            if (_groupId != null) ...[
              SizedBox(height: 16.0),
              Text('Group ID: $_groupId'),
            ],
          ],
        ),
      ),
    );
  }
}
