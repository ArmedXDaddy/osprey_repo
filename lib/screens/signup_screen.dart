import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osprey_app/screens/home2_screen.dart';
import 'package:osprey_app/screens/profile_setup_screen.dart';
import 'package:osprey_app/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool isGoogleSignUp = false;
  String selectedUserType = "User/Follower";

  final List<String> userTypes = [
    "User/Follower",
    "Company/Promoter/Sponsor",
    "Athlete/Influencer/Celebrity",
    "Trainee/Coach"
  ];

  // 🔹 Sign-up with Email & Password
  Future<void> _signup() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': emailController.text.trim(),
        'displayName': nameController.text.trim(),
        'photoURL': "",
        'userType': selectedUserType,
        'needsVerification': selectedUserType != "User/Follower",
        'isVerified': selectedUserType == "User/Follower",
        'createdAt': Timestamp.now(),
      });

      setState(() => isLoading = false);

      // ✅ Redirect to Profile Setup (Always)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileSetupScreen(uid: uid, userType: selectedUserType)),
      );

    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Failed: ${e.toString()}")));
    }
  }

  // 🔹 Google Sign-Up (Fixed)
  Future<void> _signUpWithGoogle() async {
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
        // 🔥 New Google user → Must select a role
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

        setState(() => isGoogleSignUp = true);
      } else {
        // ✅ Existing Google user → Redirect properly
        String userType = userDoc['userType'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileSetupScreen(uid: uid, userType: userType)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-Up Failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 10),
                Text(
                  "Join Osprey and connect with a thriving community!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 30),

                if (!isGoogleSignUp) _buildTextField(nameController, "Full Name", Icons.person),
                if (!isGoogleSignUp) _buildTextField(emailController, "Email", Icons.email),
                if (!isGoogleSignUp) _buildTextField(passwordController, "Password", Icons.lock, obscure: true),
                if (!isGoogleSignUp) _buildTextField(confirmPasswordController, "Confirm Password", Icons.lock, obscure: true),

                // 🔹 User Type Selection (Mandatory)
                DropdownButtonFormField<String>(
                  value: selectedUserType,
                  items: userTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => selectedUserType = value!),
                  decoration: const InputDecoration(labelText: "Select User Type"),
                ),

                const SizedBox(height: 10),
                const Text("User/Follower does not require verification.", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 20),

                ElevatedButton(onPressed: _signup, child: const Text("Sign Up")),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _signUpWithGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text("Sign in with Google"),
                ),

                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                  child: const Text("Already have an account? Log in", style: TextStyle(color: Colors.deepPurple)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[900],
        ),
      ),
    );
  }
}
