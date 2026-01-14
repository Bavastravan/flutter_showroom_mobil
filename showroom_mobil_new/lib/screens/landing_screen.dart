import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('ShowroomMobil', style: textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            // Layout mobile: Column
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Showroom Mobil Bekas',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Temukan mobil impianmu dengan mudah, cepat, dan transparan.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  // Foto mobil besar
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 8,
                          child: Container(
                            color: colorScheme.surfaceVariant,
                            // Ganti dengan Image.asset / Image.network sesuai kebutuhanmu
                            child: const Center(
                              child: Icon(
                                Icons.directions_car_filled,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        // TODO: navigate ke HomeScreen (list mobil)
                        // Navigator.pushNamed(context, '/home');
                      },
                      child: const Text('Lihat Showroom'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Layout desktop/tablet: Row
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  // Kiri: teks + tombol
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Showroom Mobil Bekas',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Jelajahi koleksi mobil bekas berkualitas, lengkap dengan informasi harga, kilometer, dan riwayat servis.',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            // TODO: navigate ke HomeScreen (list mobil)
                            // Navigator.pushNamed(context, '/home');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text('Lihat Showroom'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Kanan: hero image
                  Expanded(
                    flex: 4,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 10,
                        child: Container(
                          color: colorScheme.surfaceVariant,
                          // Nanti ganti dengan gambar mobil beneran
                          child: const Center(
                            child: Icon(
                              Icons.directions_car_filled,
                              size: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
