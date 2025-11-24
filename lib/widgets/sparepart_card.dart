import 'package:flutter/material.dart';
import '../models/sparepart_model.dart';
import '../themes/text_styles.dart';

class SparepartCard extends StatelessWidget {
  final SparepartModel sparepart;
  final VoidCallback onTap;

  const SparepartCard({required this.sparepart, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // PILIH Image.asset atau Image.network secara otomatis:
    final isAsset = sparepart.gambarUrl.startsWith('assets/');
    Widget imageWidget = isAsset
        ? Image.asset(
            sparepart.gambarUrl,
            width: 90,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.extension, size: 38, color: theme.disabledColor),
          )
        : Image.network(
            sparepart.gambarUrl,
            width: 90,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.extension, size: 38, color: theme.disabledColor),
          );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
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
                    Text(
                      sparepart.nama,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(sparepart.merk, style: AppTextStyles.body2),
                    const SizedBox(height: 4),
                    Text('Rp${sparepart.harga}', style: AppTextStyles.heading2),
                    if ((sparepart.rating ?? 0) > 0)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            sparepart.rating!.toStringAsFixed(1),
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
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
