import 'package:flutter/material.dart';
import '../models/sparepart_model.dart';
import '../themes/text_styles.dart';

class SparepartCard extends StatelessWidget {
  final SparepartModel sparepart;
  final VoidCallback onTap;

  const SparepartCard({required this.sparepart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.network(
                sparepart.gambarUrl,
                width: 90,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.extension),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sparepart.nama, style: AppTextStyles.heading3),
                    SizedBox(height: 4),
                    Text(sparepart.merk, style: AppTextStyles.body2),
                    SizedBox(height: 4),
                    Text('Rp${sparepart.harga}', style: AppTextStyles.heading2),
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
