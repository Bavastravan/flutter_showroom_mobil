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
      home: HomePage(),
    );
  }
}

/* =========================
   HALAMAN UTAMA
========================= */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Halo Speeders",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Image.asset(
              "images/toyota.jpg",
              width: 250,
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Ini adalah contoh mobil sport modern dengan desain aerodinamis.",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailPage(),
                  ),
                );
              },
              child: const Text("Detail"),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   HALAMAN DETAIL
========================= */
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Mobil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("images/toyota.jpg"),
            const SizedBox(height: 16),
            const Text(
              "Toyota GR Supra",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Toyota GR Supra adalah mobil sport yang dikembangkan oleh Toyota "
              "dengan performa tinggi dan desain modern. Mobil ini memiliki mesin "
              "yang bertenaga, handling yang stabil, serta interior yang dirancang "
              "untuk kenyamanan pengemudi.",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}