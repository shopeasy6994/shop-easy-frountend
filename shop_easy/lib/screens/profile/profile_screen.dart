import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${authProvider.user?.name ?? 'Guest'}'),
            Text('Email: ${authProvider.user?.email ?? 'N/A'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
