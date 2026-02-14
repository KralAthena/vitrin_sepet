import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VitrinSepetApp());
}

class VitrinSepetApp extends StatelessWidget {
  const VitrinSepetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitrinSepet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
