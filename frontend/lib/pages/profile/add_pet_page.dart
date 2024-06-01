import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/components/animal_info_list.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  @override
  Widget build(BuildContext context) {
    return const AnimalInfoList();
  }
}
