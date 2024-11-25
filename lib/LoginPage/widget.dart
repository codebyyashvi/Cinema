import 'package:cinema/LoginPage/auth.dart'; // Ensure this is the correct import
import 'package:cinema/main.dart';
import 'package:cinema/LoginPage/loginregisterpage.dart'; // Correct import path
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, // Corrected method name
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(); // Redirect to HomePage if user is authenticated
        } else {
          return const LoginPage(); // Redirect to LoginPage if user is not authenticated
        }
      },
    );
  }
}
