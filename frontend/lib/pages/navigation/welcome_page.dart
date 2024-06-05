import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/pages/auth/signin_page.dart';
import 'package:frontend/pages/navigation/profile_page.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<Map<String, dynamic>> user;
  int currentPage = 0;
  List<Widget> pages = [
    const ProfilePage(),
  ];
  Future<Map<String, dynamic>> getUserInfo() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:4000/loggedIn"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firebaseuid': uid,
        }),
      );

      final data = jsonDecode(res.body);
      if (!mounted) return data;

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    user = getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data!;
            final username = data["username"];
            context.read<UserProvider>().userId = data["userid"];
            return Text("Welcome, $username!");
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const SigninPage();
                  },
                ),
              );
            },
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}
