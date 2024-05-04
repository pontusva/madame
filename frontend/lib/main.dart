import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Madame());
}

class Madame extends StatelessWidget {
  const Madame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Madame'),
        ),
        body: const SignupPage(),
      ),
    );
  }
}
