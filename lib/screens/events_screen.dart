import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsScreen extends StatefulWidget {
  final String uid;

  const EventsScreen({super.key, required this.uid});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;
          if (events.isEmpty) {
            return const Center(child: Text("No Upcoming Events"));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  title: Text(event['title'] ?? "Untitled Event"),
                  subtitle: Text(event['date'] ?? "No Date"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('event_registrations').add({
                        'eventId': event.id,
                        'userId': widget.uid
                      });
                    },
                    child: const Text("Register"),
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
