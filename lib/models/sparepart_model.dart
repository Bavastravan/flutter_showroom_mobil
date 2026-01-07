import 'package:cloud_firestore/cloud_firestore.dart';

class SparepartModel {
  final String id;
  final String nama;
  final String gambarUrl;
  final int harga;
  final String merk;
  final String deskripsi; // selalu non-null (default "")
  final double? rating;   // tambah rating (opsional, dari Firestore)

  SparepartModel({
    required this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.merk,
    required this.deskripsi,
    this.rating,
  });

  // Mapping dari Firestore, field null/absent selalu dijadikan default
  factory SparepartModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return SparepartModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      gambarUrl: data['gambarUrl'] ?? '',
      harga: data['harga'] ?? 0,
      merk: data['merk'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      rating: (data['rating'] as num?)?.toDouble(), // <-- mapping rating, aman dari null!
    );
  }

  // Untuk upload/update ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'gambarUrl': gambarUrl,
      'harga': harga,
      'merk': merk,
      'deskripsi': deskripsi,
      'rating': rating,
    };
  }
}
