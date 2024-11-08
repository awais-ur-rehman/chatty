import 'package:flutter/material.dart';
import 'package:frontend/screens/chat/group_chat_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/search_user_screen.dart';
import 'screens/chat/create_group_screen.dart';
import 'screens/chat/join_group_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const ChattyApp());
}

class ChattyApp extends StatelessWidget {
  const ChattyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatty',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        hintColor: AppColors.hintColor,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          background: AppColors.backgroundColor,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());
          case '/otpVerification':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => OTPVerificationScreen(
                  email: args['email'] ?? '',
                  token: args['token'] ?? '',
                ),
              );
            }
            return _errorRoute();
          case '/home':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => HomeScreen(userName: args['userName'] ?? ''),
              );
            }
            return _errorRoute();
          case '/searchUser':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => SearchUserScreen(
                  userName: args['userName'] ?? '',
                ),
              );
            }
            return _errorRoute();
          case '/groupChat':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => GroupChatScreen(
                  userName: args['userName'] ?? '',
                  groupId: args['groupId'] ?? '',
                ),
              );
            }
            return _errorRoute();
          case '/createGroup':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => CreateGroupScreen(
                  userName: args['userName'] ?? '',
                ),
              );
            }
            return _errorRoute();
          case '/joinGroup':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => JoinGroupScreen(
                  userName: args['userName'] ?? '',
                ),
              );
            }
            return _errorRoute();
          case '/chat':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => ChatScreen(
                  userName: args['userName'] ?? '',
                  chatPartnerName: args['chatPartnerName'] ?? '',
                  selectedLanguage: args['selectedLanguage'] ?? 'en',
                ),
              );
            }
            return _errorRoute();
          default:
            return _errorRoute();
        }
      },
    );
  }

  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Something went wrong!'),
          ),
        );
      },
    );
  }
}
