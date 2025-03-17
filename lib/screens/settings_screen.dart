import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:osprey_app/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String uid;

  const SettingsScreen({super.key, required this.uid});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool emailNotifications = true;
  bool pushNotifications = true;

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value);
                },
              ),
            ),
            ListTile(
              title: const Text("Email Notifications"),
              trailing: Switch(
                value: emailNotifications,
                onChanged: (value) {
                  setState(() => emailNotifications = value);
                },
              ),
            ),
            ListTile(
              title: const Text("Push Notifications"),
              trailing: Switch(
                value: pushNotifications,
                onChanged: (value) {
                  setState(() => pushNotifications = value);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
