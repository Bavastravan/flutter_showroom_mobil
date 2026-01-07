import 'package:cloud_firestore/cloud_firestore.dart';

class MobilModel {
  final String? id;
  final String nama;
  final String gambarUrl;
  final int harga;
  final String tahun;
  final String transmisi;
  final String merk;
  final String? deskripsi; // opsional
  final double? rating;    // opsional, untuk data rating mobil

  MobilModel({
    this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.tahun,
    required this.transmisi,
    required this.merk,
    this.deskripsi,
    this.rating,
  });

  // Mapping dari Firestore
  factory MobilModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MobilModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      gambarUrl: data['gambarUrl'] ?? '',
      harga: data['harga'] ?? 0,
      tahun: data['tahun'] ?? '',
      transmisi: data['transmisi'] ?? '',
      merk: data['merk'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      rating: (data['rating'] as num?)?.toDouble(),   // ambil rating (jika ada) sebagai double
    );
  }

  // Untuk mapping ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'gambarUrl': gambarUrl,
      'harga': harga,
      'tahun': tahun,
      'transmisi': transmisi,
      'merk': merk,
      'deskripsi': deskripsi ?? '',
      'rating': rating, // sertakan jika ingin update ke database
    };
  }
}
