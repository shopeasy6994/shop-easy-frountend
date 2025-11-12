import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Manage Addresses'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('My Rewards'),
            onTap: () {},
          ),
          if (user != null && user.referralCode.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Referral Code'),
              subtitle: Text(user.referralCode),
              onTap: () {
                // Logic to share the code
              },
            ),
        ],
      ),
    );
  }
}
