import 'package:flutter/material.dart';

class AddPetPage extends StatelessWidget {
  const AddPetPage({super.key});

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
        title: const Text('Add Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          // shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return const Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Species',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Size',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Color',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Markings',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Microchip Number',
                    border: border,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Collar and tags',
                    border: border,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
