import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/add_pet_page.dart';
import 'package:http/http.dart' as http;

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
          final data = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final imageUrl = data[index]['imageurl'];
              return SizedBox(
                width: 400,
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        data[index]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: Image.network(
                            'http://10.0.2.2:4000/images/$imageUrl',
                            fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
