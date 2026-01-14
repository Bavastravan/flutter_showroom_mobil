import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/sparepart_model.dart';
import '../../themes/text_styles.dart';

class DetailSparepartScreen extends StatelessWidget {
  const DetailSparepartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Validasi Arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! String) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("ID Sparepart tidak valid")),
      );
    }
    final String sparepartId = args;

    // Helper format rupiah
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp', 
      decimalDigits: 0
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Sparepart'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('spareparts').doc(sparepartId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Sparepart tidak ditemukan'));
            }

            final sparepart = SparepartModel.fromFirestore(snapshot.data!);
            
            // Data Dummy / Tambahan
            final double ratingSparepart = sparepart.rating ?? 4.5;
            const String namaToko = "Toko Sparepart Jaya";
            const double ratingToko = 4.8;

            // Cek apakah gambar dari internet atau asset lokal
            bool isNetworkImage = sparepart.gambarUrl.startsWith('http');

            // === SOLUSI RESPONSIF (LayoutBuilder) ===
            return LayoutBuilder(
              builder: (context, constraints) {
                // Batasi lebar konten di desktop agar tidak gepeng
                bool isWideScreen = constraints.maxWidth > 600;
                double contentWidth = isWideScreen ? 600 : double.infinity;

                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Stack(
                      children: [
                        // === 1. KONTEN SCROLLABLE ===
                        Padding(
                          padding: const EdgeInsets.only(bottom: 90), // Ruang untuk Bottom Bar
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ====== GAMBAR PRODUK (ASPECT RATIO) ======
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.grey[100],
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9, // Rasio 16:9 agar konsisten
                                      child: isNetworkImage
                                          ? Image.network(
                                              sparepart.gambarUrl,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(child: CircularProgressIndicator());
                                              },
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                                    Text("Gagal memuat", style: TextStyle(color: Colors.grey)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              sparepart.gambarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ====== JUDUL & RATING ======
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                                    const SizedBox(width: 6),
                                    Text(
                                      ratingSparepart.toStringAsFixed(1),
                                      style: AppTextStyles.heading2.copyWith(fontSize: 18, color: Colors.black87),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        sparepart.nama,
                                        style: AppTextStyles.heading1.copyWith(fontSize: 22, color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // ====== INFO SPESIFIKASI (KOTAK ABU) ======
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildSpecItem('Merk', sparepart.merk, Icons.branding_watermark),
                                      _buildSpecItem('Kondisi', 'Baru', Icons.check_circle_outline), // Data Dummy
                                      _buildSpecItem('Stok', 'Tersedia', Icons.inventory_2_outlined), // Data Dummy
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ====== HARGA ======
                                Text(
                                  currencyFormatter.format(sparepart.harga),
                                  style: AppTextStyles.heading1.copyWith(
                                    color: Colors.blue[800],
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Divider(height: 40, thickness: 1),

                                // ====== DESKRIPSI ======
                                Text('Deskripsi Produk', style: AppTextStyles.heading2.copyWith(color: Colors.black)),
                                const SizedBox(height: 8),
                                Text(
                                  (sparepart.deskripsi.isNotEmpty)
                                      ? sparepart.deskripsi
                                      : 'Deskripsi detail sparepart belum tersedia.',
                                  style: AppTextStyles.body1.copyWith(
                                    height: 1.6, 
                                    color: Colors.grey[800],
                                    fontSize: 15
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const Divider(height: 40),

                                // ====== INFO TOKO ======
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.blueGrey,
                                        child: Icon(Icons.store, color: Colors.white),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(namaToko, style: AppTextStyles.heading3.copyWith(color: Colors.black87)),
                                            const SizedBox(height: 4),
                                            Row(children: [
                                              const Icon(Icons.verified, size: 14, color: Colors.blue),
                                              Text(' Terpercaya • $ratingToko', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                            ]),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                                        child: const Text("Kunjungi"),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // ====== ULASAN PEMBELI ======
                                Text('Ulasan Pembeli', style: AppTextStyles.heading2.copyWith(color: Colors.black)),
                                const SizedBox(height: 12),
                                _buildCommentSection(sparepartId),
                                
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        // === 2. STICKY BOTTOM BAR ===
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: const Offset(0, -4),
                                  blurRadius: 16,
                                )
                              ],
                            ),
                            child: SafeArea(
                              child: Row(
                                children: [
                                  // Tombol Chat
                                  _buildIconActionButton(
                                    icon: Icons.chat_outlined,
                                    label: "Chat",
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  // Tombol Wishlist (Icon Only)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                                      onPressed: () {},
                                      tooltip: 'Wishlist',
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Tombol Pesan Sekarang
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[700],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Fitur pesan segera hadir!')),
                                        );
                                      },
                                      child: const Text(
                                        'Pesan Sekarang',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN (HELPER) ---

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.grey[500]),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
      ],
    );
  }

  Widget _buildIconActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: Colors.black87,
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildCommentSection(String sparepartId) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('spareparts')
          .doc(sparepartId)
          .collection('komentar')
          .orderBy('tanggal', descending: true)
          .limit(3)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (snapshot.data!.docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: const Text('Belum ada ulasan untuk produk ini.', style: TextStyle(color: Colors.grey)),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 14, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, size: 16, color: Colors.white)),
                        const SizedBox(width: 8),
                        Text(data['namaUser'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        const Spacer(),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(' ${data['rating'] ?? 5}', style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(data['komentar'] ?? '-', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}