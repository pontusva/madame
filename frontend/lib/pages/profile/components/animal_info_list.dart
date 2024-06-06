import "dart:io";
import 'dart:convert';
import "package:flutter/material.dart";
import 'package:frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import "package:image_picker/image_picker.dart";
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class AnimalInfoList extends StatefulWidget {
  const AnimalInfoList({super.key});

  @override
  State<AnimalInfoList> createState() => _AnimalInfoListState();
}

class _AnimalInfoListState extends State<AnimalInfoList> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  File? galleryFile;
  List<dynamic>? _cities;
  String? _selectedState;
  String _selectedCity = '';

  final picker = ImagePicker();
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

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  void saveForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _formData['user_id'] = context.read<UserProvider>().userId.toString();
      var response = await http.post(
        Uri.parse('http://localhost:4000/upload'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(_formData),
      );

      if (response.statusCode == 200) {
        print('Form data submitted!');
      } else {
        print('Failed to submit form data: ${response.statusCode}');
      }
    }
  }

  void uploadImage(BuildContext context) async {
    if (galleryFile != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://localhost:4000/uploadImage'));

      // Add userId to request
      String userId = context.read<UserProvider>().userId.toString();
      request.fields['userId'] = userId;

      // Add file to request
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        galleryFile!.path,
        contentType: MediaType.parse('image/jpeg'),
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Uploaded!');
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<UserProvider>().userId);
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
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Animal Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Name'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Species',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Species'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a species';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Breed'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a breed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Age'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Size'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a size';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Color'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a color';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Markings',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Markings'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter markings';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Collar and tags',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Collar and tags'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter collar and tags';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Microchip',
                      border: border,
                    ),
                    items: <String>['Yes', 'No']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Handle change
                    },
                    onSaved: (value) => _formData['Microchip'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  ),
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
                            !snapshot.data!.any((dynamic value) =>
                                value['iso2'] == _selectedState)) {
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
                      items: _cities!
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['name'],
                          child: Text(value['name']),
                        );
                      }).toList(),
                    ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Area',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Area'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter collar and tags';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    child: const Text('Select Image from Gallery and Camera'),
                    onPressed: () {
                      _showPicker(context: context);
                    },
                  ),
                  galleryFile == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 200.0,
                          width: 300.0,
                          child: Center(child: Image.file(galleryFile!)),
                        ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        galleryFile = null;
                      });
                    },
                    icon: galleryFile != null
                        ? const Icon(Icons.delete)
                        : const SizedBox.shrink(),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                    child: const Text('Submit'),
                    onPressed: () {
                      saveForm();
                      uploadImage(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
