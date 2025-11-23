import 'package:flutter/material.dart';

class SparepartScreen extends StatelessWidget {
  const SparepartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Sparepart')),
      body: const Center(child: Text('Daftar sparepart tersedia')),
    );
  }
}
