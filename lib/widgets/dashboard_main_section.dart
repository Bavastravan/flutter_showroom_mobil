import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardMainSection extends StatefulWidget {
  const DashboardMainSection({super.key});

  @override
  State<DashboardMainSection> createState() => _DashboardMainSectionState();
}

class _DashboardMainSectionState extends State<DashboardMainSection> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar dinonaktifkan/tinggi 0 karena kita buat custom header di body
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 0,
      ),
      body: ListView(
        // BouncingScrollPhysics agar scroll terasa natural di Android/iOS
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // === 1. HEADER & SEARCH BAR ===
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 18, 10, 10),
            child: Row(
              children: [
                // Tombol Back
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                
                const SizedBox(width: 8),

                // Search Bar
                Expanded(
                  child: SizedBox(
                    height: 42, // Sedikit diperbesar agar teks tidak terpotong di HP font besar
                    child: TextField(
                      readOnly: true,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 20),
                        hintText: "Cari mobil, sparepart...",
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                        ),
                        fillColor: theme.cardColor,
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Tombol More
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  icon: Icon(Icons.more_vert, color: theme.iconTheme.color, size: 26),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // === 2. INFORMASI TOKO ===
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Toko
                CircleAvatar( 
                  radius: 28,
                  backgroundImage: const AssetImage('assets/images/showroom_logo.png'), 
                  onBackgroundImageError: (_, __) {
                    debugPrint("Gagal memuat gambar profil");
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.store, color: Colors.white70),
                ),
                const SizedBox(width: 12), 

                // Info Teks (Nama, Rating, Lokasi)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Showroom Mobil Bekas Jaya',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.9', 
                            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified, color: Colors.blue, size: 14),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              '1123 Member',
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Jl. Sukses Menuju Harapan, No. 3, Blok A, Indonesia',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 4),
                
                // Tombol Aksi (Share & Chat)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      icon: Icon(Icons.share, color: theme.colorScheme.primary, size: 22),
                      onPressed: () {},
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      icon: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // === 3. TAB HEADER ===
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  _DashboardTabItem(
                    label: 'Showroom',
                    selected: tabIndex == 0,
                    onTap: () => setState(() => tabIndex = 0),
                  ),
                  _DashboardTabItem(
                    label: 'Produk',
                    selected: tabIndex == 1,
                    onTap: () => setState(() => tabIndex = 1),
                  ),
                  _DashboardTabItem(
                    label: 'Kategori',
                    selected: tabIndex == 2,
                    onTap: () => setState(() => tabIndex = 2),
                  ),
                  _DashboardTabItem(
                    label: 'Live',
                    selected: tabIndex == 3,
                    onTap: () => setState(() => tabIndex = 3),
                  ),
                ],
              ),
            ),
          ),

          // === 4. TAB CONTENT ===
          _DashboardTabView(tabIndex: tabIndex),
        ],
      ),
    );
  }
}

class _DashboardTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DashboardTabItem({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque, // Agar area kosong juga bisa diklik
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              // Indikator garis bawah jika dipilih
              Container(
                height: 3,
                width: 28,
                decoration: BoxDecoration(
                  color: selected ? theme.colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTabView extends StatelessWidget {
  final int tabIndex;
  const _DashboardTabView({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (tabIndex) {
      case 0:
        return const _ShowroomTabBody();
      case 1:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text('Produk (fitur lanjut)', style: theme.textTheme.bodyLarge),
          ),
        );
      case 2:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text('Kategori (fitur lanjut)', style: theme.textTheme.bodyLarge),
          ),
        );
      case 3:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text('Live (fitur lanjut)', style: theme.textTheme.bodyLarge),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ShowroomTabBody extends StatelessWidget {
  const _ShowroomTabBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    
    // Logika Responsive kolom grid
    final crossAxis = width < 600 ? 2 : 4; // 2 kolom di HP, 4 di Desktop
    
    // PERBAIKAN: Rasio aspek disesuaikan agar card tidak terlalu pendek (text terpotong)
    // atau terlalu panjang.
    final childRatio = width < 600 ? 0.70 : 0.75; 

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECTION MOBIL
          Text('Semua Mobil', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('mobils').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Belum ada data mobil'),
                );
              }

              final docs = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Agar scroll ikut parent
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: childRatio,
                ),
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return _ProductCard(
                    imageUrl: data['gambarUrl'] ?? '',
                    title: data['nama'] ?? '-',
                    subtitle: data['merk'] ?? '',
                    price: (data['harga'] ?? 0) as int,
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // SECTION SPAREPART
          Text('Semua Sparepart', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('spareparts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('Belum ada sparepart');
              }

              final docs = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: childRatio,
                ),
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return _ProductCard(
                    imageUrl: data['gambarUrl'] ?? '',
                    title: data['nama'] ?? '-',
                    subtitle: data['merk'] ?? '',
                    price: (data['harga'] ?? 0) as int,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final int price;

  const _ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // === LOGIKA PENGECEKAN TIPE GAMBAR ===
    // Jika string dimulai dengan http, anggap itu URL Internet.
    // Jika tidak, anggap itu path Aset Lokal.
    bool isNetworkImage = imageUrl.startsWith('http');

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.black12,
      color: theme.cardColor,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. GAMBAR (Menggunakan Expanded agar mengisi sisa ruang vertikal)
            Expanded(
              child: Container(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: imageUrl.isEmpty 
                  ? Center(child: Icon(Icons.image, color: theme.disabledColor))
                  : (isNetworkImage 
                      // JIKA IMAGE DARI INTERNET
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.broken_image_outlined, 
                              size: 28, color: theme.disabledColor),
                          ),
                        )
                      // JIKA IMAGE DARI ASET LOKAL
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.broken_image_outlined, 
                              size: 28, color: theme.disabledColor),
                          ),
                        )
                    ),
              ),
            ),

            // 2. INFORMASI PRODUK
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  
                  // Subtitle (Merk)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Harga
                  Text(
                    currencyFormatter.format(price),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}