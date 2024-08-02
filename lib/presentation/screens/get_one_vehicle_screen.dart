// another_screen.dart
import 'package:flutter/material.dart';

class ListOneVehicleScreen extends StatelessWidget {
  const ListOneVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get One Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Another Screen!'),
      ),
    );
  }
}
