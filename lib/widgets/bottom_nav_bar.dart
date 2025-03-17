import 'package:flutter/material.dart';
import 'package:osprey_app/screens/home2_screen.dart';
import 'package:osprey_app/screens/events_screen.dart';
import 'package:osprey_app/screens/find_people_screen.dart';
import 'package:osprey_app/screens/messages_screen.dart';
import 'package:osprey_app/screens/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String uid;
  final String userType;

  const BottomNavBar({super.key, required this.uid, required this.userType});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(uid: widget.uid, userType: widget.userType),
      EventsScreen(uid: widget.uid),       // ✅ Pass uid
      FindPeopleScreen(uid: widget.uid),   // ✅ Pass uid
      MessagesScreen(uid: widget.uid),     // ✅ Pass uid
      SettingsScreen(uid: widget.uid),     // ✅ Pass uid
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Find"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
