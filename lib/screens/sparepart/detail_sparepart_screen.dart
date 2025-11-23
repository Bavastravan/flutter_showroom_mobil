import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sparepart_model.dart';
import '../../themes/text_styles.dart';

class DetailSparepartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String sparepartId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Sparepart'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('spareparts').doc(sparepartId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: AppTextStyles.body2));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Sparepart tidak ditemukan', style: AppTextStyles.body2));
          }

          final sparepart = SparepartModel.fromFirestore(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      sparepart.gambarUrl,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.extension, size: 120),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(sparepart.nama, style: AppTextStyles.heading2),
                  SizedBox(height: 8),
                  Text('Merk: ${sparepart.merk}', style: AppTextStyles.body1),
                  SizedBox(height: 8),
                  Text('Harga: Rp${sparepart.harga}', style: AppTextStyles.heading1),
                  Divider(height: 32, thickness: 1),
                  Text('Deskripsi:', style: AppTextStyles.heading3),
                  SizedBox(height: 4),
                  (sparepart.deskripsi != null && sparepart.deskripsi!.isNotEmpty)
                    ? Text(sparepart.deskripsi!, style: AppTextStyles.body2)
                    : Text('(Deskripsi sparepart belum tersedia)', style: AppTextStyles.body2),
                  SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Pesan Sparepart Ini'),
                      onPressed: () {
                        // TODO: Integrasi fitur pemesanan/transaksi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fitur pesan sparepart belum aktif')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
