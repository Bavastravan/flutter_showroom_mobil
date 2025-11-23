import 'package:flutter/material.dart';

class BengkelScreen extends StatelessWidget {
  const BengkelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bengkel Terdekat')),
      body: const Center(child: Text('Daftar bengkel terdekat')),
    );
  }
}
