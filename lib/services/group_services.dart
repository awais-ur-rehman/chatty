import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class GroupService {
  Future<Map<String, dynamic>?> createGroup(String userName, String groupName) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/groups/create-group'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userName,
        'groupName': groupName,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
