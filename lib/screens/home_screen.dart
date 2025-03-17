import 'package:flutter/material.dart';
import 'package:osprey_app/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(), // Creates balanced vertical spacing

            // 🟣 App Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset('assets/logo.png', height: 180, fit: BoxFit.contain), // Ensure this exists
            ),
            const SizedBox(height: 20),

            // 🟣 App Name
            Text(
              "OSPREY",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade800,
                letterSpacing: 2.0,
              ),
            ),

            // 🟣 Tagline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Text(
                "Empowering Women, Together.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),

            // 🟣 Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Join a community built to uplift and empower women across all fields. "
                "Connect, collaborate, and grow together.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5, // Increases readability
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🟣 Get Started Button with animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)), // Slide-up effect
                    child: child,
                  ),
                );
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const Spacer(), // Keeps everything centered nicely
          ],
        ),
      ),
    );
  }
}
