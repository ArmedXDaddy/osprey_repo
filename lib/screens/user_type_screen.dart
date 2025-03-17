import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osprey_app/screens/home2_screen.dart';

class UserTypeScreen extends StatefulWidget {
  final String uid;

  const UserTypeScreen({super.key, required this.uid});

  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String selectedUserType = "User/Follower";

  final List<String> userTypes = [
    "User/Follower",
    "Company/Promoter/Sponsor",
    "Athlete/Influencer/Celebrity",
    "Trainee/Coach"
  ];

  void _continue() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'userType': selectedUserType,
      'needsVerification': selectedUserType != "User/Follower",
      'isVerified': selectedUserType == "User/Follower",
    });

    // Redirect to Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(uid: widget.uid, userType: selectedUserType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Your Role", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 20),
              
              Column(
                children: userTypes.map((type) {
                  return RadioListTile<String>(
                    title: Text(type),
                    value: type,
                    groupValue: selectedUserType,
                    onChanged: (value) => setState(() => selectedUserType = value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: _continue,
                child: const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
