import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahasiswa Skripsi 2023',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(
        title: 'Daftar Mahasiswa Siap Skripsi',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  /// Data: Angkatan 2023, S1 & D3 STMIK Amikom Surakarta
  final List<Map<String, dynamic>> items = const [
    {
      'name': 'Ahmad Fajar Pratama',
      'photo': 'https://i.pravatar.cc/150?img=1',
      'nim': '23.11.0001',
      'tahunMasuk': 2023,
      'prodi': 'S1 Informatika',
      'publikasi': '1 Jurnal Nasional Terindeks Sinta 4',
      'akademik': 'IPK 3.65, SKS lulus 118/144',
      'administratif': 'Bebas pustaka & bebas tanggungan keuangan',
      'eligible': true,
    },
    {
      'name': 'Bella Putri Ayu',
      'photo': 'https://i.pravatar.cc/150?img=2',
      'nim': '23.31.0002',
      'tahunMasuk': 2023,
      'prodi': 'D3 Sistem Informasi',
      'publikasi': '1 Artikel Prosiding Seminar Kampus',
      'akademik': 'IPK 3.40, SKS lulus 80/110',
      'administratif': 'Masih menunggu verifikasi bebas pustaka',
      'eligible': false,
    },
    {
      'name': 'Carlos Nugroho',
      'photo': 'https://i.pravatar.cc/150?img=3',
      'nim': '23.21.0003',
      'tahunMasuk': 2023,
      'prodi': 'S1 Sistem Informasi',
      'publikasi': '2 Artikel Blog Teknis (internal lab)',
      'akademik': 'IPK 3.20, SKS lulus 110/144',
      'administratif': 'Administrasi sudah lengkap',
      'eligible': false,
    },
    {
      'name': 'Dinda Maharani',
      'photo': 'https://i.pravatar.cc/150?img=4',
      'nim': '23.41.0004',
      'tahunMasuk': 2023,
      'prodi': 'D3 Manajemen Informatika',
      'publikasi': 'Belum ada publikasi ilmiah',
      'akademik': 'IPK 3.10, SKS lulus 76/110',
      'administratif': 'Sedang proses pengajuan bebas tanggungan',
      'eligible': false,
    },
    {
      'name': 'Eka Saputra',
      'photo': 'https://i.pravatar.cc/150?img=5',
      'nim': '23.11.0005',
      'tahunMasuk': 2023,
      'prodi': 'S1 Informatika',
      'publikasi': '1 Jurnal Nasional & 1 Seminar Kampus',
      'akademik': 'IPK 3.80, SKS lulus 120/144',
      'administratif': 'Semua persyaratan administratif terpenuhi',
      'eligible': true,
    },
    {
      'name': 'Fani Lestari',
      'photo': 'https://i.pravatar.cc/150?img=6',
      'nim': '23.11.0006',
      'tahunMasuk': 2023,
      'prodi': 'S1 Informatika',
      'publikasi': '1 Artikel Prosiding Nasional',
      'akademik': 'IPK 3.45, SKS lulus 112/144',
      'administratif': 'Masih menunggu verifikasi keuangan',
      'eligible': false,
    },
    {
      'name': 'Gilang Ramadhan',
      'photo': 'https://i.pravatar.cc/150?img=7',
      'nim': '23.21.0007',
      'tahunMasuk': 2023,
      'prodi': 'S1 Sistem Informasi',
      'publikasi': '1 Artikel Blog Lab Riset',
      'akademik': 'IPK 3.25, SKS lulus 108/144',
      'administratif': 'Persyaratan administrasi lengkap',
      'eligible': true,
    },
    {
      'name': 'Hana Putri Salma',
      'photo': 'https://i.pravatar.cc/150?img=8',
      'nim': '23.31.0008',
      'tahunMasuk': 2023,
      'prodi': 'D3 Sistem Informasi',
      'publikasi': 'Belum ada publikasi ilmiah',
      'akademik': 'IPK 3.05, SKS lulus 72/110',
      'administratif': 'Sedang proses bebas pustaka',
      'eligible': false,
    },
    {
      'name': 'Ivan Aditya',
      'photo': 'https://i.pravatar.cc/150?img=9',
      'nim': '23.41.0009',
      'tahunMasuk': 2023,
      'prodi': 'D3 Manajemen Informatika',
      'publikasi': '1 Artikel Prosiding Seminar Kampus',
      'akademik': 'IPK 3.30, SKS lulus 90/110',
      'administratif': 'Administrasi lengkap',
      'eligible': true,
    },
    {
      'name': 'Jihan Nur Azizah',
      'photo': 'https://i.pravatar.cc/150?img=10',
      'nim': '23.11.0010',
      'tahunMasuk': 2023,
      'prodi': 'S1 Informatika',
      'publikasi': '1 Jurnal Nasional',
      'akademik': 'IPK 3.70, SKS lulus 122/144',
      'administratif': 'Semua persyaratan terpenuhi',
      'eligible': true,
    },
  ];

  // Helper status skripsi
  Color _getEligibilityColor(bool eligible, ColorScheme scheme) {
    if (eligible) return Colors.green.shade50;
    return scheme.error.withOpacity(0.08);
  }

  Color _getEligibilityTextColor(bool eligible) =>
      eligible ? Colors.green.shade800 : Colors.red.shade700;

  String _getEligibilityText(bool eligible) => eligible
      ? 'LAYAK SKRIPSI'
      : 'BELUM LAYAK (Perlu melengkapi persyaratan)';

  IconData _getEligibilityIcon(bool eligible) =>
      eligible ? Icons.check_circle : Icons.error_outline;

    @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.4),
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Kandidat Skripsi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Angkatan 2023 • STMIK Amikom Surakarta | by Ardian 550',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final bool eligible = item['eligible'] as bool;
            final statusText = _getEligibilityText(eligible);
            final name = item['name'] as String;
            final nim = item['nim'] as String;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name | $nim • $statusText'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon profil mahasiswa (gaya jas/dasi)
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // DETAIL TEKS + ICON
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama + menu icon
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                nim,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Prodi + tahun masuk
                              Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    size: 16,
                                    color: Colors.indigo.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${item['prodi']} • Masuk ${item['tahunMasuk']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Riwayat publikasi
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 16,
                                    color: Colors.teal.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item['publikasi'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Persyaratan akademik & administratif
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 16,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['akademik'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['administratif'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                             // BADGE STATUS SKRIPSI
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  // hapus width: double.infinity kalau mau ikut lebar teks saja
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getEligibilityColor(eligible, colorScheme),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,           // chip, tapi aman
                                    children: [
                                      Icon(
                                        _getEligibilityIcon(eligible),
                                        size: 18,
                                        color: _getEligibilityTextColor(eligible),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(                               // penting: biar wrap
                                        child: Text(
                                          _getEligibilityText(eligible),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _getEligibilityTextColor(eligible),
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}