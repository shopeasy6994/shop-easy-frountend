import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen needs its logic implemented using AuthProvider
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('OTP screen UI goes here.'),
        ),
      ),
    );
  }
}
