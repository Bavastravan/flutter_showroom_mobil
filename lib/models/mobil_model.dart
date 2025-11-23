import 'package:cloud_firestore/cloud_firestore.dart';

class MobilModel {
  final String? id;
  final String nama;
  final String gambarUrl;
  final int harga;
  final String tahun;
  final String transmisi;
  final String merk;

  MobilModel({
    this.id,
    required this.nama,
    required this.gambarUrl,
    required this.harga,
    required this.tahun,
    required this.transmisi,
    required this.merk,
  });

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'gambarUrl': gambarUrl,
      'harga': harga,
      'tahun': tahun,
      'transmisi': transmisi,
      'merk': merk,
    };
  }
}
