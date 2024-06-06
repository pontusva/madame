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
      body: Center(
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
            Text('Name: ${widget.name}'),
            Text('Species: ${widget.species}'),
            Text('Breed: ${widget.breed}'),
            Text('Age: ${widget.age.toString()}'),
            Text('Image URL: ${widget.imageUrl}'),
            Text('Size: ${widget.size}'),
            Text('Color: ${widget.color}'),
            Text('Markings: ${widget.markings}'),
            Text('Collar and Tags: ${widget.collarAndTags}'),
            Text('Microchip: ${widget.microchip ? 'Yes' : 'No'}'),
            Text('City: ${widget.city}'),
            Text('Region: ${widget.region}'),
            Text('Area: ${widget.area}'),
          ],
        ),
      ),
    );
  }
}
