class User {
  final int? id;
  final String nama;
  final String email;
  final String foto;
  final String nomorHp;
  final String alamat;
  final String password; // Tambahkan jika pakai autentikasi manual

  User({
    this.id,
    required this.nama,
    required this.email,
    required this.foto,
    required this.nomorHp,
    required this.alamat,
    required this.password,
  });

  // Konversi dari Map (untuk ambil dari SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      foto: map['foto'] ?? '',
      nomorHp: map['nomorHp'] ?? '',
      alamat: map['alamat'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Konversi ke Map (untuk dimasukkan ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'foto': foto,
      'nomorHp': nomorHp,
      'alamat': alamat,
      'password': password,
    };
  }

  // Utility: membandingkan instance User dengan ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  // Utility: untuk debug print
  @override
  String toString() {
    return 'User{id: $id, nama: $nama, email: $email, foto: $foto, nomorHp: $nomorHp, alamat: $alamat, password: $password}';
  }
}
