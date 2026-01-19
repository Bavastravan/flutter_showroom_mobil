import 'package:cloud_firestore/cloud_firestore.dart';

class MobilModel {
  final String? id;
  final String nama;
  final String gambarUrl;
  final int harga;
  final String tahun;
  final String transmisi;
  final String merk;
  final String? deskripsi;
  final double? rating;

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

  // Mapping dari Firestore (VERSI ROBUST / ANTI-CRASH)
  factory MobilModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return MobilModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      gambarUrl: data['gambarUrl'] ?? '',
      
      // FIX PENTING: Paksa konversi ke String dulu, baru ke int
      // Ini mengatasi jika di Firebase tersimpan sebagai "235000000" (String) atau 235000000 (Number)
      harga: int.tryParse(data['harga'].toString()) ?? 0,
      
      // FIX TAHUN: Pastikan jadi String meskipun di DB tersimpan sebagai angka (misal 2021)
      tahun: data['tahun']?.toString() ?? '',
      
      transmisi: data['transmisi'] ?? '',
      merk: data['merk'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      
      // FIX RATING: Paksa konversi ke double
      // Ini mengatasi jika rating di DB adalah 4 (Int) atau "4.5" (String)
      rating: double.tryParse(data['rating'].toString()) ?? 0.0,
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
      'rating': rating,
    };
  }
}