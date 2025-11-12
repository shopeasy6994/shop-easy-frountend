import 'package:flutter/material.dart';

class ItemRequestScreen extends StatelessWidget {
  const ItemRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request an Item')),
      body: const Center(child: Text('Item request form goes here.')),
    );
  }
}
