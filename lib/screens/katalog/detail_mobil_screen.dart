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
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('mobils').doc(mobilId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists)
            return Center(child: Text('Mobil tidak ditemukan', style: AppTextStyles.body2));

          final mobil = MobilModel.fromFirestore(snapshot.data!);

          double ratingMobil = mobil.rating ?? 4.7;
          String namaShowroom = "Showroom Mobil Bekas Jaya";
          double ratingShowroom = 4.9;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 74),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== Gambar Mobil ======
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            mobil.gambarUrl,
                            height: 170,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.directions_car, size: 120),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // ====== Rating Mobil & Nama ======
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                          SizedBox(width: 4),
                          Text(ratingMobil.toStringAsFixed(1), style: AppTextStyles.heading2),
                          SizedBox(width: 12),
                          Text('•', style: AppTextStyles.heading2), // GANTI heading2 AGAR TIDAK ERROR
                          SizedBox(width: 12),
                          Expanded(child: Text(mobil.nama, style: AppTextStyles.heading2, maxLines: 2, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Info Mobil
                      Row(
                        children: [
                          Text('Merk: ${mobil.merk}', style: AppTextStyles.body1),
                          SizedBox(width: 12),
                          Text('Tahun: ${mobil.tahun}', style: AppTextStyles.body1),
                          SizedBox(width: 12),
                          Text('Transmisi: ${mobil.transmisi}', style: AppTextStyles.body1),
                        ],
                      ),
                      SizedBox(height: 6),

                      Text('Harga: Rp${mobil.harga}', style: AppTextStyles.heading1),
                      Divider(height: 32, thickness: 1),
                      Text('Tentang Mobil', style: AppTextStyles.heading3),
                      SizedBox(height: 4),
                      mobil.deskripsi != null && mobil.deskripsi!.isNotEmpty
                          ? Text(mobil.deskripsi!, style: AppTextStyles.body2)
                          : Text('(Deskripsi mobil belum tersedia)', style: AppTextStyles.body2),
                      Divider(height: 28),

                      // ===== Komentar & Review =====
                      Text('Review & Komentar', style: AppTextStyles.heading3),
                      SizedBox(height: 6),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('mobils')
                            .doc(mobilId)
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
                                          Text((data['rating'] ?? 5.0).toString(), style: TextStyle(fontSize: 13, color: Colors.amber)),
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
                      Divider(height: 30),

                      // ===== Showroom Info ====
                      Row(
                        children: [
                          Icon(Icons.store, color: Colors.blueGrey, size: 22),
                          SizedBox(width: 8),
                          Expanded(child: Text(namaShowroom, style: AppTextStyles.heading3)),
                          Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(ratingShowroom.toStringAsFixed(1), style: AppTextStyles.heading2),
                        ],
                      ),
                      Divider(height: 32),

                      // ======= Produk Lain Kami =======
                      SizedBox(height: 10),
                      Text('Produk Lain Kami', style: AppTextStyles.heading2),
                      SizedBox(height: 8),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('mobils')
                            .limit(6)
                            .get(),
                        builder: (context, prodSnap) {
                          if (prodSnap.connectionState == ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          if (!prodSnap.hasData || prodSnap.data!.docs.isEmpty)
                            return Text('Produk lain belum tersedia', style: AppTextStyles.body2);

                          final otherMobils = prodSnap.data!.docs
                              .where((doc) => doc.id != mobil.id)
                              .map((doc) => MobilModel.fromFirestore(doc))
                              .toList();
                          if (otherMobils.isEmpty)
                            return Text('Produk lain belum tersedia', style: AppTextStyles.body2);

                          return SizedBox(
                            height: 155,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: otherMobils.length,
                              separatorBuilder: (_, __) => SizedBox(width: 12),
                              itemBuilder: (context, idx) {
                                final m = otherMobils[idx];
                                return SizedBox(
                                  width: 130,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, '/katalog/detail-mobil', arguments: m.id);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                m.gambarUrl,
                                                height: 64,
                                                width: 114,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Icon(Icons.directions_car),
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(m.nama, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                                            SizedBox(height: 2),
                                            Text('Rp${m.harga}', style: AppTextStyles.heading3, maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // ======= Sticky Bottom Bar Buttons Shopee-like =======
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
                            elevation: 0
                          ),
                          onPressed: () {
                            // TODO: Navigasi chat ke showroom
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
                            // TODO: Tambahkan ke wishlist user
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
                            Navigator.pushNamed(context, '/katalog/detail-mobil/booking', arguments: mobil.id);
                          },
                          child: Text('Beli'),
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
