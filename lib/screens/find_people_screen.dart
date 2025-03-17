import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindPeopleScreen extends StatefulWidget {
  final String uid;

  const FindPeopleScreen({super.key, required this.uid});

  @override
  _FindPeopleScreenState createState() => _FindPeopleScreenState();
}

class _FindPeopleScreenState extends State<FindPeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find People")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;
          if (users.isEmpty) {
            return const Center(child: Text("No Users Found"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['photoURL'] != null
                        ? NetworkImage(user['photoURL'])
                        : null,
                    child: user['photoURL'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['displayName'] ?? "Unnamed User"),
                  subtitle: Text(user['userType'] ?? "Unknown Role"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('followers').add({
                        'followerId': widget.uid,
                        'followingId': user.id
                      });
                    },
                    child: const Text("Follow"),
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
