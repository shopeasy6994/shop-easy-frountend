import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ADD THIS IMPORT

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to SHOP EASY', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login screen using go_router
                context.go('/login');
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // You would navigate to a registration screen here
                // For now, let's point it to login as a placeholder
                // context.go('/register');
              },
              child: const Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
