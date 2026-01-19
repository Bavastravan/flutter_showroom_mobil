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

            final bool isNetworkImage =
                sparepart.gambarUrl.startsWith('http');

            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isWideScreen = constraints.maxWidth > 600;
                final double contentWidth =
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
                                // ====== GAMBAR SPAREPART ======
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
                                              sparepart.gambarUrl,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
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
                                              sparepart.gambarUrl,
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
                                    Text(
                                      'Terjual:',
                                      style: textTheme.bodyMedium
                                          ?.copyWith(
                                        color: colorScheme
                                            .onSurfaceVariant,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '123 unit', // dummy
                                      style: textTheme.bodyMedium
                                          ?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // ====== SPESIFIKASI ======
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
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
                                        sparepart.merk,
                                        Icons
                                            .branding_watermark,
                                      ),
                                      _buildSpecItem(
                                        context,
                                        'Kondisi',
                                        'Baru',
                                        Icons
                                            .check_circle_outline,
                                      ),
                                      _buildSpecItem(
                                        context,
                                        'Stok',
                                        'Tersedia',
                                        Icons
                                            .inventory_2_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ====== HARGA ======
                                Text(
                                  currencyFormatter
                                      .format(sparepart.harga),
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
                                  'Deskripsi Produk',
                                  style: AppTextStyles.heading2
                                      .copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  sparepart.deskripsi.isNotEmpty
                                      ? sparepart.deskripsi
                                      : 'Deskripsi detail sparepart belum tersedia.',
                                  style: AppTextStyles.body1
                                      .copyWith(
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

                                // ====== INFO SHOWROOM (TOKO) ======
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 4),
                                  child: Card(
                                    elevation: 3,
                                    color: colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: colorScheme
                                            .outlineVariant,
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical: 18.0,
                                        horizontal: 20.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                const AssetImage(
                                              'assets/images/showroom_logo.png',
                                            ),
                                            backgroundColor: theme
                                                .colorScheme.primary
                                                .withOpacity(0.1),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  namaToko,
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                    color: colorScheme
                                                        .onSurface,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                ),
                                                const SizedBox(
                                                    height: 5),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors
                                                          .amber,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                        width: 3),
                                                    Text(
                                                      ratingToko
                                                          .toStringAsFixed(
                                                              1),
                                                      style: theme
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        color:
                                                            colorScheme.onSurface,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 10),
                                                    const Icon(
                                                      Icons
                                                          .verified_rounded,
                                                      color:
                                                          Colors.blue,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(
                                                        width: 3),
                                                    Text(
                                                      '1123 Member',
                                                      style: theme
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color:
                                                            colorScheme.onSurfaceVariant,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: 7),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .location_on,
                                                      color: theme
                                                          .colorScheme
                                                          .primary,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                        width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Pemasaran : Jl. Sukses Menuju Harapan, No. 3, Blok A, Indonesia',
                                                        style: theme
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                          color: theme
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color
                                                              ?.withOpacity(
                                                                  0.9),
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: 10),
                                                Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child:
                                                      ElevatedButton(
                                                    onPressed:
                                                        () {
                                                      Navigator
                                                          .push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  const DashboardMainSection(),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          colorScheme
                                                              .primary,
                                                      foregroundColor:
                                                          colorScheme
                                                              .onPrimary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal:
                                                            14,
                                                        vertical:
                                                            7,
                                                      ),
                                                      textStyle: theme
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Kunjungi Showroom',
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
                                const SizedBox(height: 30),

                                // ====== KOMENTAR ======
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ulasan Pembeli',
                                      style:
                                          AppTextStyles.heading2
                                              .copyWith(
                                        color: colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          ratingSparepart
                                              .toStringAsFixed(1),
                                          style: textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: colorScheme
                                                .primary,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(100 ulasan)',
                                          style: textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildCommentSection(
                                  context,
                                  sparepartId,
                                ),
                                const SizedBox(height: 30),
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
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    theme.brightness ==
                                            Brightness.dark
                                        ? 0.4
                                        : 0.08,
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
                                      // TODO: tambah ke wishlist
                                    },
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: colorScheme.primary,
                                    ),
                                    tooltip:
                                        'Tambah ke Wishlist',
                                  ),
                                  const SizedBox(width: 12),

                                  // Pesan + Keranjang (sparepart, bukan booking)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                                  colorScheme
                                                      .secondary,
                                              foregroundColor:
                                                  colorScheme
                                                      .onSecondary,
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                vertical: 16,
                                              ),
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                            12),
                                              ),
                                              elevation: 2,
                                            ),
                                            onPressed: () {
                                              // TODO: ke form / beli sparepart
                                              ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Fitur pesan sparepart belum aktif',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Pesan Sekarang',
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
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
                                            Icons
                                                .shopping_cart_outlined,
                                            color:
                                                colorScheme.primary,
                                          ),
                                          tooltip:
                                              'Tambah ke Keranjang',
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
    String sparepartId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Belum ada ulasan untuk produk ini.',
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              colorScheme.primary,
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data['namaUser'] ?? 'User',
                          style: textTheme.bodyMedium
                              ?.copyWith(
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
                          style: textTheme.bodySmall
                              ?.copyWith(
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
}
