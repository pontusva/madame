import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/add_pet_page.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ManagePetsPage extends StatefulWidget {
  const ManagePetsPage({super.key});

  @override
  State<ManagePetsPage> createState() => _ManagePetsPageState();
}

class _ManagePetsPageState extends State<ManagePetsPage> {
  late Future<List<dynamic>> animalInfo;

  Future<List<dynamic>> getAnimalInfo() async {
    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:4000/animalInfo"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': "6",
        }),
      );

      final data = jsonDecode(res.body);
      print(data);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    animalInfo = getAnimalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 35,
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPetPage(),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        title: const Text('Manage Pets'),
      ),
      body: Scaffold(
        body: FutureBuilder(
          future: animalInfo,
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
            final username = data[0]['imageurl'];
            return Text("Welcome, $username");
          },
        ),
      ),
    );
  }
}
