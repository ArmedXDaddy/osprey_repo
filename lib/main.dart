import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osprey_app/screens/home_screen.dart';
import 'package:osprey_app/screens/login_screen.dart';
import 'package:osprey_app/screens/signup_screen.dart';
import 'package:osprey_app/screens/forgot_password_screen.dart';
import 'package:osprey_app/screens/user_type_screen.dart';
import 'package:osprey_app/screens/home2_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const OspreyApp());
}

class OspreyApp extends StatelessWidget {
  const OspreyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Osprey App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
