import 'package:flutter/material.dart';
import '../models/mobil_model.dart';
import '../themes/text_styles.dart';

class MobilCard extends StatelessWidget {
  final MobilModel mobil;
  final VoidCallback onTap;

  const MobilCard({required this.mobil, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.network(
                mobil.gambarUrl,
                width: 90,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.directions_car),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mobil.nama, style: AppTextStyles.heading3),
                    SizedBox(height: 4),
                    Text('${mobil.tahun} | ${mobil.transmisi}', style: AppTextStyles.body2),
                    SizedBox(height: 4),
                    Text('Rp${mobil.harga}', style: AppTextStyles.heading2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
