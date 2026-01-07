import 'package:flutter/material.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps Showroom')),
      body: const Center(child: Text('Peta lokasi showroom/bengkel')),
    );
  }
}
