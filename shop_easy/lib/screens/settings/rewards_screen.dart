import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/auth_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: Center(
        child: Column(
          // FIXED: Corrected the constructor call
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Reward Coins',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              user?.rewardCoins.toString() ?? '0',
              style: const TextStyle(fontSize: 48, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
