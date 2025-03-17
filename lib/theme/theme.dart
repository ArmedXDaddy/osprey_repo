import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.grey),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
  ),
);
