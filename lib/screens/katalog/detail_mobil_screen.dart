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

          // Dummy nilai rating mobil & rating showroom
          double ratingMobil = mobil.rating ?? 4.7; // field rating double di Firestore (opsional)
          String namaShowroom = "Showroom Mobil Bekas Jaya";
          double ratingShowroom = 4.9;

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

                  // ====== Rating Mobil ======
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                      SizedBox(width: 4),
                      Text(ratingMobil.toStringAsFixed(1), style: AppTextStyles.heading1),
                      SizedBox(width: 8),
                      Text('★★★★★', style: TextStyle(fontSize: 18, color: Colors.amber)),
                    ],
                  ),
                  SizedBox(height: 8),

                  // ====== Info Mobil ======
                  Text(mobil.nama, style: AppTextStyles.heading2),
                  SizedBox(height: 8),
                  Text('Merk: ${mobil.merk}', style: AppTextStyles.body1),
                  Text('Tahun: ${mobil.tahun}', style: AppTextStyles.body1),
                  Text('Transmisi: ${mobil.transmisi}', style: AppTextStyles.body1),
                  SizedBox(height: 8),
                  Text('Harga: Rp${mobil.harga}', style: AppTextStyles.heading1),
                  Divider(height: 32, thickness: 1),
                  SizedBox(height: 4),

                  // ====== Tentang Mobil ======
                  Text('Tentang Mobil:', style: AppTextStyles.heading3),
                  SizedBox(height: 4),
                  mobil.deskripsi != null && mobil.deskripsi!.isNotEmpty
                      ? Text(mobil.deskripsi!, style: AppTextStyles.body2)
                      : Text('(Deskripsi mobil ini - tambahkan field "deskripsi" di Firestore jika mau)', style: AppTextStyles.body2),

                  SizedBox(height: 28),

                  // ====== Komentar/Review Pengguna ======
                  Text('Komentar & Review Pengguna:', style: AppTextStyles.heading3),
                  SizedBox(height: 6),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('mobils')
                        .doc(mobilId)
                        .collection('komentar')
                        .orderBy('tanggal', descending: true)
                        .get(),
                    builder: (context, reviewSnap) {
                      if (reviewSnap.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!reviewSnap.hasData || reviewSnap.data!.docs.isEmpty) {
                        return Text('Belum ada komentar / review.', style: AppTextStyles.body2);
                      }
                      return Column(
                        children: reviewSnap.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: (data['tipeMedia'] == 'foto' && data['mediaUrl'] != null)
                                  ? Image.network(data['mediaUrl'], width: 56, height: 56, fit: BoxFit.cover)
                                  : (data['tipeMedia'] == 'video' && data['mediaUrl'] != null)
                                    ? Icon(Icons.videocam, size: 40, color: Colors.blueGrey)
                                    : Icon(Icons.person, size: 40),
                              title: Text(data['namaUser'] ?? 'Pengguna', style: AppTextStyles.body1),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['komentar'] ?? '-', style: AppTextStyles.body2),
                                  if (data['tipeMedia'] == 'video' && data['mediaUrl'] != null)
                                    Text('Video terlampir'),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 16, color: Colors.amber),
                                      Text((data['rating'] ?? 5.0).toString(), style: TextStyle(fontSize: 13, color: Colors.amber)),
                                    ],
                                  ),
                                ],
                              ),
                              // trailing, dst. bisa ditambah: tanggal dsb.
                            ),
                          );
                        }).toList(),
                      );
                    }
                  ),

                  SizedBox(height: 28),

                  // ==== Nama dan Rating Showroom ====
                  Divider(height: 8),
                  Row(
                    children: [
                      Icon(Icons.store, color: Colors.blueGrey),
                      SizedBox(width: 8),
                      Expanded(child: Text(namaShowroom, style: AppTextStyles.heading3)),
                      Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      SizedBox(width: 4),
                      Text(ratingShowroom.toStringAsFixed(1), style: AppTextStyles.heading2),
                    ],
                  ),
                  Divider(height: 32),

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
