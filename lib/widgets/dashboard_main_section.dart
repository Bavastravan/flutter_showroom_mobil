import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Pastikan package intl sudah ada di pubspec.yaml

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,

        children: [

          Padding(
  padding: const EdgeInsets.fromLTRB(10, 18, 10, 10), // Short-hand padding
  child: Row(
    children: [
      // 1. TOMBOL BACK (Dioptimalkan)
      IconButton(
        // 'constraints' & 'padding' ini kuncinya. 
        // Default IconButton memakan ruang 48x48. Kita kecilkan area sentuhnya.
        constraints: const BoxConstraints(), 
        padding: const EdgeInsets.all(8), 
        icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
      
      const SizedBox(width: 8), // Beri sedikit jarak manual

      // 2. SEARCH BAR (Flexible/Expanded)
      Expanded(
        child: SizedBox(
          height: 41,
          child: TextField(
            readOnly: true,
            // Tambahkan maxLines 1 agar teks tidak turun ke bawah
            maxLines: 1, 
            textAlignVertical: TextAlignVertical.center, // Pastikan teks di tengah vertikal
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 20),
              // textOverflow ellipsis: Jika hint kepanjangan, akan jadi titik-titik (...)
              hintText: "Cari mobil, sparepart...", 
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                overflow: TextOverflow.ellipsis, 
              ),
              fillColor: theme.cardColor,
              filled: true,
              isDense: true, // Membuat internal padding lebih rapat
              contentPadding: const EdgeInsets.symmetric(horizontal: 12), // Padding vertikal otomatis diatur isDense
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(23),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 8), // Beri sedikit jarak manual

      // 3. TOMBOL MORE (Dioptimalkan)
      IconButton(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
        icon: Icon(Icons.more_vert, color: theme.iconTheme.color, size: 26),
        onPressed: () {},
      ),
    ],
  ),
),
          
        Padding(
  padding: const EdgeInsets.fromLTRB(12, 16, 12, 10), // Sedikit tambah padding atas agar lega
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Pastikan vertikal di tengah
    children: [
      // 1. AVATAR (Ukuran Tetap)
      const CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage('assets/images/showroom_logo.png'),
        backgroundColor: Colors.grey,
      ),
      const SizedBox(width: 12), 

      // 2. INFORMASI TENGAH (MENGISI SISA RUANG / RESPONSIVE)
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nama Showroom
            Text(
              'Showroom Mobil Bekas Jaya',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Baris Rating & Member
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
                Flexible( // Flexible mencegah overflow pada layar sangat kecil
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
            
            // Baris Lokasi
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
      
      const SizedBox(width: 8), // Jarak aman antara Teks dan Tombol Aksi
      
      // 3. TOMBOL AKSI KANAN (BERSEBELAHAN)
      Row(
        mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
        children: [
          IconButton(
            constraints: const BoxConstraints(), // Memadatkan area klik
            padding: const EdgeInsets.all(8),
            // tooltip: 'Bagikan', // Opsional: Bagus untuk UX Desktop
            icon: Icon(Icons.share, color: theme.colorScheme.primary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 4), // Jarak antar tombol share dan chat
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            // tooltip: 'Chat',
            icon: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    ],
  ),
),
          // TAB HEADER
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
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: selected ? FontWeight.bold : null,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 2),
              if (selected)
                Container(
                  height: 3,
                  width: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Semua Mobil', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  // UBAH DISINI: 
                  // 0.72 membuat kartu lebih tinggi daripada 0.86.
                  // Semakin kecil angka, semakin tinggi kartunya.
                  childAspectRatio: 0.72, 
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
          
          Text('Semua Sparepart', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          
          // Lakukan hal yang sama untuk Grid Sparepart
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
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  // Samakan rasionya
                  childAspectRatio: 0.72,
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

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: theme.cardColor,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GAMBAR (Flexible)
            // Menggunakan Expanded adalah solusi paling aman untuk Grid.
            // Gambar akan mengisi sisa ruang setelah teks dirender.
            Expanded(
              child: Container(
                width: double.infinity,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: imageUrl.isNotEmpty
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
                            size: 32, color: theme.disabledColor),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.image_outlined, 
                          size: 32, color: theme.disabledColor),
                      ),
              ),
            ),

            // 2. INFORMASI PRODUK
            // Kita bungkus dengan Padding saja (tanpa Expanded) agar ukurannya
            // menyesuaikan konten teks.
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Penting!
                children: [
                  // Judul
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1, // Batasi 1 baris agar aman
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  
                  // Subtitle
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
                      fontWeight: FontWeight.bold,
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