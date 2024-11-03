import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Import the login page from the pages folder

void main() {
  runApp(BeautyApp());
}

class BeautyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Services App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SignInPage(), // Set the home page to be the login page
    );
  }
}
