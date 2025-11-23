import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mobil_model.dart';
import '../../themes/text_styles.dart';

class DetailMobilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String mobilId = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Mobil'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('mobils').doc(mobilId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Mobil tidak ditemukan', style: AppTextStyles.body2));
          }

          final mobil = MobilModel.fromFirestore(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      mobil.gambarUrl,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.directions_car, size: 120),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(mobil.nama, style: AppTextStyles.heading2),
                  SizedBox(height: 8),
                  Text('Merk: ${mobil.merk}', style: AppTextStyles.body1),
                  Text('Tahun: ${mobil.tahun}', style: AppTextStyles.body1),
                  Text('Transmisi: ${mobil.transmisi}', style: AppTextStyles.body1),
                  SizedBox(height: 8),
                  Text('Harga: Rp${mobil.harga}', style: AppTextStyles.heading1),
                  Divider(height: 32, thickness: 1),
                  Text(
                    'Tentang Mobil:',
                    style: AppTextStyles.heading3,
                  ),
                  SizedBox(height: 4),
                  Text('(Deskripsi mobil opsional - tambahkan field "deskripsi" di Firestore jika mau)', style: AppTextStyles.body2),
                  SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.book_online),
                      label: Text('Booking Mobil Ini'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/katalog/detail-mobil/booking', arguments: mobil.id);
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
