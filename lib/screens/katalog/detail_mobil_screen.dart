import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/mobil_model.dart';
import '../../themes/text_styles.dart';
import 'package:showroom_mobil/widgets/dashboard_main_section.dart';

class DetailMobilScreen extends StatelessWidget {
  const DetailMobilScreen({Key? key}) : super(key: key);

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
        body: const Center(child: Text("ID Mobil tidak valid")),
      );
    }
    final String mobilId = args;

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
    title: const Text('Detail Mobil'),
  ),
  body: SafeArea(
    child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('mobils')
          .doc(mobilId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text(
              'Mobil tidak ditemukan',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          );
        }

        final mobil = MobilModel.fromFirestore(snapshot.data!);

            // Data Dummy Showroom
            final double ratingMobil = mobil.rating ?? 4.7;
            const String namaShowroom = "Showroom Mobil Bekas Jaya";
            const double ratingShowroom = 4.9;

            // Cek tipe gambar
            bool isNetworkImage = mobil.gambarUrl.startsWith('http');

            // === SOLUSI RESPONSIF (DESKTOP & MOBILE) ===
            return LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;
                double contentWidth =
                    isWideScreen ? 600 : double.infinity;

                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Stack(
                      children: [
                        // === 1. KONTEN UTAMA (SCROLLABLE) ===
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 90),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // ====== GAMBAR MOBIL ======
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    color:
                                        colorScheme.surfaceVariant,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: isNetworkImage
                                          ? Image.network(
                                              mobil.gambarUrl,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context,
                                                  child,
                                                  loadingProgress) {
                                                if (loadingProgress ==
                                                    null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                              errorBuilder: (
                                                _,
                                                __,
                                                ___,
                                              ) {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .broken_image,
                                                        size: 40,
                                                        color: colorScheme
                                                            .outline,
                                                      ),
                                                      Text(
                                                        "Gagal memuat",
                                                        style: textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color:
                                                              colorScheme.outline,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              mobil.gambarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                _,
                                                __,
                                                ___,
                                              ) {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 40,
                                                        color: colorScheme
                                                            .outline,
                                                      ),
                                                      Text(
                                                        "Aset lokal hilang",
                                                        style: textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color:
                                                              colorScheme.outline,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
// ====== JUDUL ======
Text(
  mobil.nama,
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
    Text(
      'Terjual:',
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    ),
    const SizedBox(width: 4),
    Text(
      '123 unit', // dummy
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
const SizedBox(height: 16),



                                // ====== SPESIFIKASI ======
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        colorScheme.surfaceVariant,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colorScheme
                                          .outlineVariant,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      _buildSpecItem(
                                        context,
                                        'Merk',
                                        mobil.merk,
                                        Icons
                                            .branding_watermark,
                                      ),
                                      _buildSpecItem(
                                        context,
                                        'Tahun',
                                        mobil.tahun.toString(),
                                        Icons.calendar_today,
                                      ),
                                      _buildSpecItem(
                                        context,
                                        'Transmisi',
                                        mobil.transmisi,
                                        Icons.settings,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ====== HARGA ======
                                Text(
                                  currencyFormatter
                                      .format(mobil.harga),
                                  style:
                                      AppTextStyles.heading1.copyWith(
                                    color: colorScheme.primary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Divider(
                                  height: 40,
                                  thickness: 1,
                                  color: colorScheme.outlineVariant,
                                ),

                                // ====== DESKRIPSI ======
                                Text(
                                  'Tentang Mobil',
                                  style: AppTextStyles.heading2
                                      .copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (mobil.deskripsi != null &&
                                          mobil.deskripsi!
                                              .isNotEmpty)
                                      ? mobil.deskripsi!
                                      : 'Deskripsi detail mobil belum tersedia.',
                                  style: AppTextStyles.body1.copyWith(
                                    height: 1.6,
                                    color: colorScheme.onSurface
                                        .withOpacity(0.9),
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Divider(
                                  height: 40,
                                  color: colorScheme.outlineVariant,
                                ),
// ====== INFO SHOWROOM ======
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 4),
  child: Card(
    elevation: 3,
    color: colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: colorScheme.outlineVariant),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo showroom
          CircleAvatar(
            radius: 32,
            backgroundImage: const AssetImage('assets/images/showroom_logo.png'),
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          ),
          const SizedBox(width: 16),

          // Teks showroom
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaShowroom,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 3),
                    Text(
                      ratingShowroom.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.verified_rounded,
                        color: Colors.blue, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '1123 Member', // dummy
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,
                        color: theme.colorScheme.primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pemasaran : Jl. Sukses Menuju Harapan, No. 3, Blok A, Indonesia',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.9),
                        ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardMainSection(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
),
const SizedBox(height: 30),



                              // ====== KOMENTAR ======
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Ulasan Pembeli',
      style: AppTextStyles.heading2.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    const SizedBox(height: 4),
    Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          ratingMobil.toStringAsFixed(1),
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(100 ulasan)', // dummy
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  ],
),
const SizedBox(height: 12),
_buildCommentSection(
  context,
  mobilId,
),
const SizedBox(height: 30),



                                // ====== PRODUK LAIN ======
                                Text(
                                  'Rekomendasi Lainnya',
                                  style: AppTextStyles.heading2
                                      .copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildOtherProducts(
                                  context,
                                  mobilId,
                                ),
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
      color: colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            theme.brightness == Brightness.dark ? 0.4 : 0.08,
          ),
          offset: const Offset(0, -4),
          blurRadius: 16,
        ),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          // Chat
          _buildIconActionButton(
            context: context,
            icon: Icons.chat_outlined,
            label: "Chat",
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Wishlist (Love)
          IconButton(
            onPressed: () {
              // TODO: tambahkan ke wishlist
            },
            icon: Icon(
              Icons.favorite_border,
              color: colorScheme.primary,
            ),
            tooltip: 'Tambah ke Wishlist',
          ),
          const SizedBox(width: 12),

          // Beli + Keranjang
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/katalog/detail-mobil/booking',
                        arguments: mobil.id,
                      );
                    },
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: tambah ke keranjang
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: colorScheme.primary,
                  ),
                  tooltip: 'Tambah ke Keranjang',
                ),
              ],
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

  // --- WIDGET BANTUAN ---

  Widget _buildSpecItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: colorScheme.secondary,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: colorScheme.onSurface,
          ),
        ),
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
    final colorScheme = theme.colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundColor: colorScheme.onSurface,
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildCommentSection(
    BuildContext context,
    String mobilId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('mobils')
          .doc(mobilId)
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
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Belum ada ulasan untuk mobil ini.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: colorScheme.primary,
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data['namaUser'] ?? 'User',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        Text(
                          ' ${data['rating'] ?? 5}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['komentar'] ?? '-',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildOtherProducts(
    BuildContext context,
    String currentId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('mobils')
          .limit(6)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final otherMobils = snapshot.data!.docs
            .where((doc) => doc.id != currentId)
            .map((doc) => MobilModel.fromFirestore(doc))
            .toList();

        if (otherMobils.isEmpty) {
          return Text(
            'Tidak ada rekomendasi lain.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );
        }

        return SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: otherMobils.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final m = otherMobils[index];
              bool isOtherNetwork = m.gambarUrl.startsWith('http');

              return SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/katalog/detail-mobil',
                      arguments: m.id,
                    );
                  },
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: isOtherNetwork
                                ? Image.network(
                                    m.gambarUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    m.gambarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(
                                      Icons.error,
                                      color: colorScheme.error,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp${m.harga}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
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
            },
          ),
        );
      },
    );
  }
}
