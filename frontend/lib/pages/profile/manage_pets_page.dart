import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/add_pet_page.dart';
import 'package:frontend/pages/profile/components/pet_page.dart';
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
        Uri.parse("http://localhost:4000/animalInfo"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': context.read<UserProvider>().userId.toString(),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetPage(
                                name: data[index]['name'],
                                species: data[index]['species'],
                                breed: data[index]['breed'],
                                age: data[index]['age'],
                                size: data[index]['size'],
                                color: data[index]['color'],
                                markings: data[index]['markings'],
                                collarAndTags: data[index]['collar_and_tags'],
                                microchip: data[index]['microchip'],
                                city: data[index]['city'],
                                region: data[index]['region'],
                                area: data[index]['area'],
                                imageUrl: data[index]['imageurl'],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'http://localhost:4000/images/$imageUrl',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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
