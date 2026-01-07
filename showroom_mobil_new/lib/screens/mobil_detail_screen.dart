import 'package:flutter/material.dart';
import '../models/mobil_model.dart';

class MobilDetailScreen extends StatelessWidget {
  final MobilModel mobil;
  const MobilDetailScreen({super.key, required this.mobil});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(mobil.namaMobil),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  color: colorScheme.surfaceVariant,
                  // TODO: ganti dengan Image.network(mobil.fotoUrl ?? ...)
                  child: const Center(
                    child: Icon(Icons.directions_car_filled, size: 80),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              mobil.namaMobil,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${mobil.merk} • Tahun ${mobil.tahun}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${mobil.harga}',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('KM: ${mobil.kilometer ?? 0}')),
                Chip(label: Text('Transmisi: ${mobil.transmisi}')),
                Chip(label: Text('BBM: ${mobil.bahanBakar}')),
                Chip(
                  label: Text(mobil.status.toUpperCase()),
                  backgroundColor: mobil.status == 'ready'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (mobil.deskripsi != null && mobil.deskripsi!.isNotEmpty)
              Text(
                mobil.deskripsi!,
                style: textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
