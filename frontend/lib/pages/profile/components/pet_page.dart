import 'package:flutter/material.dart';

class PetPage extends StatefulWidget {
  final String name;
  final String species;
  final String breed;
  final int age;
  final String size;
  final String color;
  final String markings;
  final String collarAndTags;
  final bool microchip;
  final String city;
  final String region;
  final String area;
  final String imageUrl;

  const PetPage({
    super.key,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.size,
    required this.color,
    required this.markings,
    required this.collarAndTags,
    required this.microchip,
    required this.city,
    required this.region,
    required this.area,
  });

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'http://localhost:4000/images/${widget.imageUrl}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some space
              Text('Name: ${widget.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                'Species: ${widget.species}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Breed: ${widget.breed}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Age: ${widget.age.toString()}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Size: ${widget.size}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Color: ${widget.color}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Markings: ${widget.markings}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Collar and Tags: ${widget.collarAndTags}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Microchip: ${widget.microchip ? 'Yes' : 'No'}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'City: ${widget.city}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Region: ${widget.region}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Area: ${widget.area}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
