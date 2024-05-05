import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/add_pet_page.dart';

class ManagePetsPage extends StatelessWidget {
  const ManagePetsPage({super.key});

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
      body: const Center(
        child: Text('Add pet'),
      ),
    );
  }
}
