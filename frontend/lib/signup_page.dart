import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Future<String>? userCredential;

  final TextEditingController textEditingControllerUserName =
      TextEditingController();
  final TextEditingController textEditingControllerPassword =
      TextEditingController();

  Future<void> signUp() async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: textEditingControllerUserName.text,
        password: textEditingControllerPassword.text,
      );
      createAlbum(user.user?.uid as String);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const SnackBar(
          content: Text('The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        const SnackBar(
          content: Text('The account already exists for that email.'),
        );
      }
    } catch (e) {
      SnackBar(
        content: Text(
          e.toString(),
        ),
      );
    }
  }

  Future<http.Response> createAlbum(String uid) {
    return http.post(
      Uri.parse('http://10.0.2.2:4000/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firebaseUID': uid,
      }),
    );
  }

  @override
  void dispose() {
    textEditingControllerUserName.dispose();
    textEditingControllerPassword.dispose();
    // Clean up the controller when the widget is disposed.
    // This step is necessary to avoid memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingControllerUserName,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                focusedBorder: border,
                border: border,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              controller: textEditingControllerPassword,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                border: border,
                focusedBorder: border,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await signUp();
                setState(() {});
              },
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
