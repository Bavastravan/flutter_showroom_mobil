class MobilModel {
  final int id;
  final String namaMobil;
  final String merk;
  final int tahun;
  final int harga;
  final int? kilometer;
  final String? warna;
  final String transmisi;    // 'manual' / 'matic'
  final String bahanBakar;   // 'bensin' / 'diesel' / 'hybrid' / 'ev'
  final String status;       // 'ready' / 'sold'
  final String? fotoUrl;
  final String? deskripsi;
  final DateTime? createdAt;

  MobilModel({
    required this.id,
    required this.namaMobil,
    required this.merk,
    required this.tahun,
    required this.harga,
    this.kilometer,
    this.warna,
    required this.transmisi,
    required this.bahanBakar,
    required this.status,
    this.fotoUrl,
    this.deskripsi,
    this.createdAt,
  });

  factory MobilModel.fromJson(Map<String, dynamic> json) {
    return MobilModel(
      id: int.parse(json['id'].toString()),
      namaMobil: json['nama_mobil'] ?? '',
      merk: json['merk'] ?? '',
      tahun: int.parse(json['tahun'].toString()),
      harga: int.parse(json['harga'].toString()),
      kilometer: json['kilometer'] != null
          ? int.tryParse(json['kilometer'].toString())
          : null,
      warna: json['warna'],
      transmisi: json['transmisi'] ?? '',
      bahanBakar: json['bahan_bakar'] ?? '',
      status: json['status'] ?? 'ready',
      fotoUrl: json['foto_url'],
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_mobil': namaMobil,
      'merk': merk,
      'tahun': tahun,
      'harga': harga,
      'kilometer': kilometer,
      'warna': warna,
      'transmisi': transmisi,
      'bahan_bakar': bahanBakar,
      'status': status,
      'foto_url': fotoUrl,
      'deskripsi': deskripsi,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
