import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osprey_app/screens/signup_screen.dart';
import 'package:osprey_app/screens/home2_screen.dart';
import 'package:osprey_app/screens/profile_setup_screen.dart';
import 'package:osprey_app/screens/verification_screen.dart';
import 'package:osprey_app/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Login with Email & Password
  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _handleLogin(userCredential.user!.uid);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: ${e.toString()}")),
      );
    }
  }

  // 🔹 Google Sign-In (Fixed)
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // 🔥 New Google user → Redirect to User Type Selection
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': googleUser.email,
          'displayName': googleUser.displayName ?? '',
          'photoURL': googleUser.photoUrl ?? '',
          'userType': null, // Force selection
          'needsVerification': false,
          'isVerified': false,
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileSetupScreen(uid: uid, userType: "")),
        );
      } else {
        // ✅ Handle existing Google User login
        await _handleLogin(uid);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: ${e.toString()}")),
      );
    }
  }

  // 🔹 Handles post-login redirection
  Future<void> _handleLogin(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!userDoc.exists) return;

    String userType = userDoc['userType'] ?? "User/Follower";
    bool isVerified = userDoc['isVerified'] ?? false;
    bool needsVerification = userDoc['needsVerification'] ?? false;

    if (userType == "User/Follower") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(uid: uid, userType: userType)),
      );
      return;
    }

    DocumentSnapshot profileDoc = await FirebaseFirestore.instance.collection('profiles').doc(uid).get();

    if (!profileDoc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileSetupScreen(uid: uid, userType: userType)),
      );
    } else if (needsVerification && !isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerificationScreen(uid: uid)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(uid: uid, userType: userType)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                },
                child: const Text("Forgot Password?", style: TextStyle(color: Colors.deepPurple)),
              ),

              ElevatedButton(
                onPressed: _loginWithEmailPassword,
                child: const Text("Login"),
              ),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
