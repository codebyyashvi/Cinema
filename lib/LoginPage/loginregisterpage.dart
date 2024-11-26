import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Sign in method
  Future<void> signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      // Navigate to profile page
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Register method
  Future<void> createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      // Create empty Firestore document for user details
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': '',
        'phoneNumber': '',
        'address': '',
        'city': '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to profile page
      Navigator.pushReplacementNamed(context, '/profile');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineLogin'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controllerEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage == '' ? '' : 'Error: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
              child: Text(isLogin ? 'Login' : 'Register'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Register instead' : 'Login instead'),
            ),
          ],
        ),
      ),
    );
  }
}
