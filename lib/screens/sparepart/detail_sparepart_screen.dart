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
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: AppTextStyles.body2));
          if (!snapshot.hasData || !snapshot.data!.exists)
            return Center(child: Text('Sparepart tidak ditemukan', style: AppTextStyles.body2));

          final sparepart = SparepartModel.fromFirestore(snapshot.data!);
          double ratingSparepart = sparepart.rating ?? 4.5;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 74),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            sparepart.gambarUrl,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.extension, size: 120),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      // ========= RATING =========
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                          SizedBox(width: 4),
                          Text(ratingSparepart.toStringAsFixed(1), style: AppTextStyles.heading1),
                          SizedBox(width: 6),
                          Text('★★★★★', style: TextStyle(fontSize: 18, color: Colors.amber)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(sparepart.nama, style: AppTextStyles.heading2),
                      SizedBox(height: 8),
                      Text('Merk: ${sparepart.merk}', style: AppTextStyles.body1),
                      SizedBox(height: 8),
                      Text('Harga: Rp${sparepart.harga}', style: AppTextStyles.heading1),
                      Divider(height: 32, thickness: 1),
                      Text('Deskripsi:', style: AppTextStyles.heading3),
                      SizedBox(height: 4),
                      sparepart.deskripsi.isNotEmpty
                          ? Text(sparepart.deskripsi, style: AppTextStyles.body2)
                          : Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  '(Deskripsi sparepart belum tersedia)',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                      Divider(height: 30),
                      // ====== Review & Komentar ======
                      Text('Review & Komentar', style: AppTextStyles.heading3),
                      SizedBox(height: 6),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('spareparts')
                            .doc(sparepartId)
                            .collection('komentar')
                            .orderBy('tanggal', descending: true)
                            .get(),
                        builder: (context, reviewSnap) {
                          if (reviewSnap.connectionState == ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          if (!reviewSnap.hasData || reviewSnap.data!.docs.isEmpty)
                            return Text('Belum ada komentar / review.', style: AppTextStyles.body2);
                          return Column(
                            children: reviewSnap.data!.docs.map((doc) {
                              final data = doc.data();
                              return Card(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: (data['tipeMedia'] == 'foto' && data['mediaUrl'] != null)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(data['mediaUrl'], width: 46, height: 46, fit: BoxFit.cover),
                                        )
                                      : (data['tipeMedia'] == 'video' && data['mediaUrl'] != null)
                                          ? Icon(Icons.videocam, size: 34, color: Colors.blueGrey)
                                          : Icon(Icons.person, size: 36),
                                  title: Text(data['namaUser'] ?? 'Pengguna', style: AppTextStyles.body1),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['komentar'] ?? '-', style: AppTextStyles.body2),
                                      if (data['tipeMedia'] == 'video' && data['mediaUrl'] != null)
                                        Text('Video terlampir'),
                                      Row(
                                        children: [
                                          Icon(Icons.star, size: 15, color: Colors.amber),
                                          Text((data['rating'] ?? 5.0).toString(),
                                              style: TextStyle(fontSize: 13, color: Colors.amber)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // ====== Sticky Bottom Bar ala Marketplace ======
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.chat),
                          label: Text('Chat Market'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade50, foregroundColor: Colors.blueGrey,
                            elevation: 0,
                          ),
                          onPressed: () {
                            // TODO: Tulis fitur chat market
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.favorite_border),
                          label: Text('Wishlist'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red),
                          ),
                          onPressed: () {
                            // TODO: Tambahkan ke wishlist
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                          onPressed: () {
                            // TODO: Arahkan ke form/beli sparepart
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Fitur pesan sparepart belum aktif')),
                            );
                          },
                          child: Text('Pesan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
