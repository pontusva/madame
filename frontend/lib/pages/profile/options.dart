import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/manage_pets_page.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text(
                'Pets',
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                'Manage your pets',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManagePetsPage(),
                  ),
                );
                // Navigate to the edit profile page
              },
            ),
            ListTile(
              title: const Text(
                'Profile',
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                'Edit your profile',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Navigate to the edit profile page
              },
            ),
            ListTile(
              title: const Text(
                'Password',
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                'Change your password',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Navigate to the change password page
              },
            ),
            ListTile(
              title: const Text(
                'Delete',
                textAlign: TextAlign.center,
              ),
              subtitle: const Text(
                'Delete your account',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Navigate to the delete account page
              },
            ),
          ],
        ),
      ],
    );
  }
}
