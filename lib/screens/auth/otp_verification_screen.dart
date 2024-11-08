import 'package:flutter/material.dart';
import '../../services/user_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String token; // Add token parameter

  OTPVerificationScreen({required this.email, required this.token});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    final userService = UserService();
    final isSuccess = await userService.verifyOTP(_otpController.text, widget.token);

    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      // Navigate to login screen
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _otpController,
              labelText: 'OTP',
              hintText: 'Enter the OTP sent to your email',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'Verify OTP',
              onPressed: _verifyOTP,
            ),
          ],
        ),
      ),
    );
  }
}
