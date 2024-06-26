import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic>? _cities;
  String? _selectedState;
  final Map<String, String> _formData = {};
  String _selectedCity = '';
  Future<List<dynamic>> getStates() async {
    try {
      final res = await http.get(
        Uri.parse("http://localhost:4000/states"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  void _fetchCities(String stateCode) async {
    final cities = await getCities(stateCode);
    setState(() {
      _cities = cities;
      if (_cities != null && _cities!.isNotEmpty) {
        _selectedCity = _cities![0]['name']; // This value exists in _cities
      }
    });
  }

  Future<List<dynamic>> getCities(String stateCode,
      {int retryCount = 3}) async {
    for (var i = 0; i < retryCount; i++) {
      try {
        final res = await http.get(
          Uri.parse("http://localhost:4000/cities?stateCode=$stateCode"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        final data = jsonDecode(res.body);
        return data;
      } catch (e) {
        if (i == retryCount - 1) {
          throw e.toString();
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw 'Failed to fetch cities after $retryCount attempts';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Pet'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<List<dynamic>>(
              future: getStates(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  if (_selectedState == null ||
                      !snapshot.data!.any(
                          (dynamic value) => value['iso2'] == _selectedState)) {
                    _selectedState = null; // Set _selectedState to null
                  }
                  return DropdownButton<String>(
                    hint: _selectedState == null
                        ? const Text("Please select a state")
                        : null, // Show the hint when _selectedState is null
                    value: _selectedState,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                        _fetchCities(newValue!);
                        _formData['Region'] = newValue;
                      });
                    },
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value['iso2'],
                        child: Text(value['name']),
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            if (_cities != null)
              DropdownButton<String>(
                hint: const Text("Please select a city"),
                value: _selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue ?? '';
                    _formData['City'] = newValue ?? '';
                  });
                },
                items: _cities!.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value['name'],
                    child: Text(value['name']),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
