import 'package:cloud_firestore/cloud_firestore.dart';
class SparepartModel {
  final String id;
  final String nama;
  final String gambarUrl;
  final int harga;
  final String merk;
  final String deskripsi; // selalu non-null (default "")

  SparepartModel({
    required this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.merk,
    required this.deskripsi,
  });

  // Mapping dari Firestore, field yang null/absent selalu dijadikan string kosong
  factory SparepartModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data() ?? {};
  return SparepartModel(
    id: doc.id,
    nama: data['nama'] ?? '',
    gambarUrl: data['gambarUrl'] ?? '',
    harga: data['harga'] ?? 0,
    merk: data['merk'] ?? '',
    deskripsi: data['deskripsi'] ?? '', // <-- anti null!
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
    };
  }
}
