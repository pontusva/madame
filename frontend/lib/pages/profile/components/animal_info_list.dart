import "dart:io";
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "package:image_picker/image_picker.dart";
import 'package:http_parser/http_parser.dart';

class AnimalInfoList extends StatefulWidget {
  const AnimalInfoList({super.key});

  @override
  State<AnimalInfoList> createState() => _AnimalInfoListState();
}

class _AnimalInfoListState extends State<AnimalInfoList> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  File? galleryFile;
  late Future<Map<String, dynamic>> user;
  final picker = ImagePicker();
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
      var response = await http.post(
        Uri.parse('http://10.0.2.2:4000/upload'),
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

  void uploadImage() async {
    if (galleryFile != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:4000/uploadImage'));

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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: border,
                    ),
                    onSaved: (value) => _formData['City'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Region',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Region'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a region';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Area',
                      border: border,
                    ),
                    onSaved: (value) => _formData['Area'] = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an area';
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
                      uploadImage();
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
