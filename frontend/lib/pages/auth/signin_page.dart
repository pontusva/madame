import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/home_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController textEditingControllerEmail =
      TextEditingController();
  final TextEditingController textEditingControllerPassword =
      TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: textEditingControllerEmail.text,
        password: textEditingControllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
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
        appBar: AppBar(
          title: const Text('Log into your account'),
        ),
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
                controller: textEditingControllerPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  helperText: "Password",
                  focusedBorder: border,
                  border: border,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  signIn();
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
                child: const Text('Sign in'),
              ),
            ],
          ),
        ));
  }
}
