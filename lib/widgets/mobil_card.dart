import 'package:flutter/material.dart';
import '../models/mobil_model.dart';
import '../themes/text_styles.dart';

class MobilCard extends StatelessWidget {
  final MobilModel mobil;
  final VoidCallback onTap;

  const MobilCard({required this.mobil, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    // Deteksi source gambar
    final bool isAsset = mobil.gambarUrl.startsWith('assets/');

    Widget imageWidget;
    if (isAsset) {
      imageWidget = Image.asset(
        mobil.gambarUrl,
        width: 90,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.directions_car, size: 48),
      );
    } else {
      imageWidget = Image.network(
        mobil.gambarUrl,
        width: 90,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.directions_car, size: 48),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mobil.nama, style: AppTextStyles.heading3),
                    const SizedBox(height: 4),
                    Text('${mobil.tahun} | ${mobil.transmisi}', style: AppTextStyles.body2),
                    const SizedBox(height: 4),
                    Text('Rp${mobil.harga}', style: AppTextStyles.heading2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
