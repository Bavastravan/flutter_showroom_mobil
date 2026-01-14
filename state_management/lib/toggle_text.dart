import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToggleText(),
    );
  }
}

class ToggleText extends StatefulWidget {
  const ToggleText({super.key});

  @override
  State<ToggleText> createState() => _ToggleTextState();
}

class _ToggleTextState extends State<ToggleText> {
  bool isVisible = true;

  void toggle() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isVisible)
              const Text(
                "Halo Apa kabarmu ?",
                style: TextStyle(fontSize: 24),
              ),
            ElevatedButton(
              onPressed: toggle,
              child: const Text("Toggle"),
            ),
          ],
        ),
      ),
    );
  }
}