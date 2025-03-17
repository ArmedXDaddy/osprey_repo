import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osprey_app/screens/login_screen.dart';
import 'package:osprey_app/screens/profile_setup_screen.dart';
import 'package:osprey_app/screens/admin_panel_screen.dart'; // Import the AdminPanelScreen

class HomeScreen extends StatefulWidget {
  final String uid;
  final String userType; // ✅ Ensure this parameter exists

  const HomeScreen({super.key, required this.uid, required this.userType});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String displayName = "";
  String profilePhoto = "";
  String email = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // ✅ Fetch user profile data
  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      if (userDoc.exists) {
        setState(() {
          displayName = userDoc['displayName'] ?? "User";
          email = userDoc['email'] ?? "";
          profilePhoto = userDoc['photoURL'] ?? "";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ✅ Logout Function
  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  // ✅ Navigate to Profile Setup Screen (for Editing Profile)
  void _goToProfileSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(uid: widget.uid, userType: widget.userType, isEditing: true),
      ),
    );
  }

  // ✅ Open Profile Bottom Sheet (Now WIDER & More Readable)
  void _openProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Allowing full-width modal
      builder: (context) {
        return Container(
          height: 380, // ✅ Increased height for better readability
          width: double.infinity, // ✅ Full width
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Profile Picture
              CircleAvatar(
                radius: 60, // ✅ Increased size
                backgroundImage: profilePhoto.isNotEmpty ? NetworkImage(profilePhoto) : null,
                child: profilePhoto.isEmpty ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),
              const SizedBox(height: 15),

              // 🔹 Name
              Text(
                displayName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),

              // 🔹 Email
              Text(email, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 10),

              // 🔹 User Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.userType,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Edit Profile Button (Larger for Better UX)
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: _goToProfileSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 Logout Button (Larger)
              SizedBox(
                width: 200,
                height: 45,
                child: TextButton(
                  onPressed: _logout,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Logout", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Osprey App"),
      actions: [
        // 🔹 Show Admin Panel Button for Admins
        if (widget.userType == "admin") 
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
              );
            },
          ),
        
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: _openProfileSheet, // ✅ Profile Sheet
        ),
        IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
      ],
    ),
    body: _buildContentForUserType(),
  );
}




  // ✅ Fix: Normalize userType for matching
  Widget _buildContentForUserType() {
    String normalizedUserType = widget.userType.toLowerCase().trim();

    if (normalizedUserType.contains("user")) {
      return _buildUserHome();
    } else if (normalizedUserType.contains("company") || normalizedUserType.contains("promoter")) {
      return _buildCompanyHome();
    } else if (normalizedUserType.contains("athlete") || normalizedUserType.contains("influencer")) {
      return _buildAthleteHome();
    } else if (normalizedUserType.contains("coach") || normalizedUserType.contains("trainee")) {
      return _buildCoachHome();
    } else {
      return _buildHomeContent(
        icon: Icons.help_outline,
        color: Colors.grey,
        title: "User type not recognized",
        subtitle: "Please update your profile or contact support.",
      );
    }
  }

  // ✅ UI for each user type
  Widget _buildUserHome() => _buildHomeContent(
        icon: Icons.people,
        color: Colors.deepPurple,
        title: "Welcome, $displayName!",
        subtitle: "Explore content and collaborate.",
      );

  Widget _buildCompanyHome() => _buildHomeContent(
        icon: Icons.business,
        color: Colors.blue,
        title: "Welcome, $displayName!",
        subtitle: "Manage your sponsorships and promotions.",
      );

  Widget _buildAthleteHome() => _buildHomeContent(
        icon: Icons.sports,
        color: Colors.green,
        title: "Welcome, $displayName!",
        subtitle: "Engage with your community and build your brand.",
      );

  Widget _buildCoachHome() => _buildHomeContent(
        icon: Icons.school,
        color: Colors.orange,
        title: "Welcome, $displayName!",
        subtitle: "Access training programs and resources.",
      );

  // ✅ Reusable UI
  Widget _buildHomeContent({required IconData icon, required Color color, required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: color),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
