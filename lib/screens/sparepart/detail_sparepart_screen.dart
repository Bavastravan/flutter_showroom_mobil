import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/sparepart_model.dart';
import '../../themes/text_styles.dart';
import 'package:showroom_mobil/widgets/dashboard_main_section.dart';

class DetailSparepartScreen extends StatelessWidget {
  const DetailSparepartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Sparepart'),
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('spareparts')
              .doc(sparepartId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text(
                  'Sparepart tidak ditemukan',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }

            final sparepart = SparepartModel.fromFirestore(snapshot.data!);

            // Data dummy toko
            final double ratingSparepart = sparepart.rating ?? 4.5;
            const String namaToko = "Toko Sparepart Jaya";
            const double ratingToko = 4.8;

            final bool isNetworkImage = sparepart.gambarUrl.startsWith('http');

            // === SOLUSI RESPONSIF ===
            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isWideScreen = constraints.maxWidth > 600;
                final double contentWidth = isWideScreen ? 600 : double.infinity;

                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Stack(
                      children: [
                        // ==========================================
                        // 1. KONTEN UTAMA (SCROLLABLE)
                        // ==========================================
                        Padding(
                          padding: const EdgeInsets.only(bottom: 90), // Jarak untuk bottom bar
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ====== GAMBAR SPAREPART ======
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    color: colorScheme.surfaceVariant,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: isNetworkImage
                                          ? Image.network(
                                              sparepart.gambarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _buildErrorImage(colorScheme, textTheme),
                                            )
                                          : Image.asset(
                                              sparepart.gambarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _buildErrorImage(colorScheme, textTheme),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ====== JUDUL ======
                                Text(
                                  sparepart.nama,
                                  style: AppTextStyles.heading1.copyWith(
                                    fontSize: 22,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('Terjual:', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 4),
                                    Text('50+ pcs', style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // ====== SPESIFIKASI ======
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colorScheme.outlineVariant),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildSpecItem(context, 'Merk', sparepart.merk, Icons.branding_watermark),
                                      _buildSpecItem(context, 'Kondisi', 'Baru', Icons.check_circle_outline),
                                      _buildSpecItem(context, 'Stok', 'Tersedia', Icons.inventory_2_outlined),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ====== HARGA ======
                                Text(
                                  currencyFormatter.format(sparepart.harga),
                                  style: AppTextStyles.heading1.copyWith(
                                    color: colorScheme.primary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Divider(height: 40, thickness: 1, color: colorScheme.outlineVariant),

                                // ====== DESKRIPSI ======
                                Text('Deskripsi Produk', style: AppTextStyles.heading2.copyWith(color: colorScheme.onSurface)),
                                const SizedBox(height: 8),
                                Text(
                                  sparepart.deskripsi.isNotEmpty
                                      ? sparepart.deskripsi
                                      : 'Deskripsi detail sparepart belum tersedia.',
                                  style: AppTextStyles.body1.copyWith(
                                    height: 1.6,
                                    color: colorScheme.onSurface.withOpacity(0.9),
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Divider(height: 40, color: colorScheme.outlineVariant),

                                // ====== INFO TOKO ======
                                _buildStoreCard(context, namaToko, ratingToko),
                                const SizedBox(height: 30),

                                // ====== KOMENTAR ======
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ulasan Pembeli', style: AppTextStyles.heading2.copyWith(color: colorScheme.onSurface)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                        const SizedBox(width: 4),
                                        Text(ratingSparepart.toStringAsFixed(1), style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 4),
                                        Text('(100 ulasan)', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildCommentSection(context, sparepartId),
                                const SizedBox(height: 30),

                                // ====== REKOMENDASI LAIN ======
                                _buildOtherProducts(context, sparepartId),
                              ],
                            ),
                          ),
                        ),

                        // ==========================================
                        // 2. STICKY BOTTOM BAR (FIXED)
                        // ==========================================
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.4 : 0.08),
                                  offset: const Offset(0, -4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: SafeArea(
                              top: false,
                              child: SizedBox(
                                height: 56,
                                child: Row(
                                  children: [
                                    // 1. Tombol Chat
                                    _buildIconActionButton(
                                      context: context,
                                      icon: Icons.chat_outlined,
                                      label: "Chat",
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 12),

                                    // 2. Tombol Pesan Sekarang + Keranjang
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // Tombol Pesan
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: colorScheme.secondary,
                                                foregroundColor: colorScheme.onSecondary,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                elevation: 2,
                                              ),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Fitur pesan sparepart belum aktif')),
                                                );
                                              },
                                              // Tombol Pesan (Expanded agar memenuhi ruang sisa)
                                  
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.secondary,
                                        foregroundColor: colorScheme.onSecondary,
                                        padding: EdgeInsets.zero, // Reset padding agar muat
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      onPressed: () {
                                        // --- NAVIGASI KE CHECKOUT SPAREPART ---
                                        Navigator.pushNamed(
                                          context,
                                          '/sparepart/pesan', // Route sesuai main.dart
                                          arguments: sparepart.id, // Kirim ID sparepart
                                        );
                                      },
                                      // FittedBox menjaga teks tetap muat di berbagai ukuran layar
                                      child: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            'Pesan Sekarang',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    
          
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),

                                          // Tombol Keranjang
                                          IconButton(
                                            onPressed: () {
                                              // TODO: Cart logic
                                            },
                                            icon: Icon(Icons.shopping_cart_outlined, color: colorScheme.primary),
                                            tooltip: 'Tambah ke Keranjang',
                                            visualDensity: VisualDensity.compact,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  // ==========================================
  // WIDGET BANTUAN (HELPER METHODS)
  // ==========================================

  Widget _buildErrorImage(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: colorScheme.outline),
          Text("Gagal memuat", style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.secondary),
        const SizedBox(height: 6),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildIconActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: theme.colorScheme.onSurface,
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildStoreCard(BuildContext context, String nama, double rating) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 3,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: const AssetImage('assets/images/showroom_logo.png'),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama, style: theme.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 3),
                        Text(rating.toStringAsFixed(1), style: theme.textTheme.bodyMedium),
                        const SizedBox(width: 10),
                        const Icon(Icons.verified_rounded, color: Colors.blue, size: 16),
                        const SizedBox(width: 3),
                        Text('1123 Member', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: theme.colorScheme.primary, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pemasaran : Jl. Sukses Menuju Harapan, No. 3, Blok A, Indonesia',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.9)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardMainSection()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          textStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Kunjungi Showroom'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context, String sparepartId) {
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Belum ada ulasan untuk produk ini.'),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(data['namaUser'] ?? 'User'),
                subtitle: Text(data['komentar'] ?? '-'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(data['rating']?.toString() ?? '5'),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildOtherProducts(BuildContext context, String currentId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi Lainnya',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('spareparts').limit(6).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final others = snapshot.data!.docs
                .where((doc) => doc.id != currentId)
                .map((doc) => SparepartModel.fromFirestore(doc))
                .toList();

            if (others.isEmpty) {
              return const Text('Tidak ada rekomendasi lain.');
            }

            return SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: others.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final s = others[index];
                  bool isOtherNetwork = s.gambarUrl.startsWith('http');

                  return SizedBox(
                    width: 150,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/sparepart/detail', // Pastikan route ini benar di main.dart
                          arguments: s.id,
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: isOtherNetwork
                                    ? Image.network(s.gambarUrl, fit: BoxFit.cover)
                                    : Image.asset(s.gambarUrl, fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Rp${s.harga}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}