import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/auth/home_page.dart';
import 'package:frontend/pages/auth/signin_page.dart';
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

  final TextEditingController textEditingControllerEmail =
      TextEditingController();
  final TextEditingController textEditingControllerName =
      TextEditingController();
  final TextEditingController textEditingControllerUsername =
      TextEditingController();
  final TextEditingController textEditingControllerPassword =
      TextEditingController();

  Future<void> signUp() async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: textEditingControllerEmail.text,
        password: textEditingControllerPassword.text,
      );
      createUser(user.user?.uid as String);
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

  Future<http.Response> createUser(String uid) {
    return http.post(
      Uri.parse('http://10.0.2.2:4000/signUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firebaseuid': uid,
        'name': textEditingControllerName.text,
        'username': textEditingControllerUsername.text,
      }),
    );
  }

  @override
  void dispose() {
    textEditingControllerEmail.dispose();
    textEditingControllerPassword.dispose();
    textEditingControllerName.dispose();
    textEditingControllerUsername.dispose();
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
              controller: textEditingControllerEmail,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                helperText: "Email",
                focusedBorder: border,
                border: border,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: textEditingControllerName,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                helperText: "name",
                focusedBorder: border,
                border: border,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: textEditingControllerUsername,
              decoration: const InputDecoration(
                hintText: 'Enter your username',
                helperText: "Username",
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
                helperText: "Password",
                border: border,
                focusedBorder: border,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await signUp();
                    FirebaseAuth.instance.userChanges().listen(
                      (User? user) {
                        if (user == null) {
                          const SnackBar(
                            content: Text('User is currently signed out!'),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: const Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SigninPage();
                        },
                      ),
                    );
                  },
                  child: const Text('or login...'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
