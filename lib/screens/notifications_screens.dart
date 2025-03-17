import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildNotificationItem("New Message", "You received a message from John."),
          _buildNotificationItem("Event Reminder", "Leadership Summit starts in 2 hours!"),
          _buildNotificationItem("New Follower", "Sarah started following you."),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
