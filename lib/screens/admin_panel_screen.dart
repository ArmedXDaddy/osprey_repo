import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  // ✅ Check if the current user is an admin
  Future<void> _checkAdminRole() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc['role'] == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // ✅ Approve User
  Future<void> _approveUser(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isVerified': true,
      'needsVerification': false,
    });

    await FirebaseFirestore.instance.collection('verification_requests').doc(uid).update({
      'status': 'Approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Approved ✅")));
  }

  // ✅ Reject User
  Future<void> _rejectUser(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isVerified': false,
      'needsVerification': false,
    });

    await FirebaseFirestore.instance.collection('verification_requests').doc(uid).update({
      'status': 'Rejected',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Rejected ❌")));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Unauthorized Access 🚫",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel - Verification Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('verification_requests').where('status', isEqualTo: 'Pending').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var requests = snapshot.data!.docs;
          if (requests.isEmpty) {
            return const Center(child: Text("No Pending Verification Requests 🎉"));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              String uid = request['uid'];
              String email = request['email'];
              String userType = request['userType'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  title: Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("User Type: $userType"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _approveUser(uid),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _rejectUser(uid),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
