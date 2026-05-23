import 'package:calculate_gpa/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculate GPA',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        primary: Colors.pink,
        secondary: Colors.pinkAccent.shade100,
        tertiary: Colors.pinkAccent
        ),
        
        fontFamily: "Gilroy"
      ),
      home: MainPage(),
    );
  }
}

