import 'package:flutter/material.dart';

class BengkelScreen extends StatelessWidget {
  const BengkelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Contoh data penawaran servis
    final List<Map<String, dynamic>> layanan = [
      {
        "icon": Icons.build_circle,
        "title": "Servis Berkala",
        "desc": "Layanan perawatan mesin & pengecekan rutin resmi showroom.",
      },
      {
        "icon": Icons.oil_barrel,
        "title": "Ganti Oli",
        "desc": "Penggantian oli mesin, oli transmisi, filter oli sesuai standar.",
      },
      {
        "icon": Icons.ac_unit,
        "title": "Servis & Perbaikan AC",
        "desc": "Cek kebocoran, isi freon, dan bersihkan sistem AC mobil.",
      },
      {
        "icon": Icons.tire_repair,
        "title": "Perbaikan Kaki-kaki",
        "desc": "Spuring, balancing, bushing, ball joint, dan suspensi.",
      },
      {
        "icon": Icons.electric_car,
        "title": "Diagnosa Elektrikal & Kelistrikan",
        "desc": "Keluhan starter, lampu, modul, sensor & aki dicek profesional.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Servis & Bengkel Showroom'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        children: [
          Text(
            'Layanan Perbaikan & Servis Berkala',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: theme.colorScheme.secondary.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.car_repair, size: 42, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Showroom Mobil Bekas Jaya menyediakan servis berkala dan perbaikan untuk semua mobil yang terdaftar di showroom ini. Dikerjakan oleh mekanik berpengalaman, jaminan sparepart asli & bergaransi!',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...layanan.map((item) => Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item['icon'], size: 36, color: theme.colorScheme.primary),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(item['desc'], style: theme.textTheme.bodyMedium, maxLines: 3),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  OutlinedButton(
                    onPressed: () {
                      // Aksi booking atau info lebih lanjut
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fitur booking servis segera tersedia!'))
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    child: const Text('Pesan'),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
