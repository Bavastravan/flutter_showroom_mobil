import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk SystemUiOverlayStyle
import '../widgets/dashboard_main_section.dart'; // Pastikan path ini benar
import 'bengkel_screen.dart'; 
import 'garansi/klaim_screen.dart'; 

// --- WIDGET PLACEHOLDER (Untuk menu yang belum ada isinya) ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const PlaceholderScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

// --- SCREEN UTAMA DASHBOARD ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Index tab yang sedang aktif

  // Daftar Halaman untuk setiap Tab
  final List<Widget> _pages = [
    const _DashboardHomeContent(), // Index 0: Beranda
    const PlaceholderScreen(title: 'Menu Terlaris', icon: Icons.star), // Index 1
    const PlaceholderScreen(title: 'Notifikasi', icon: Icons.notifications), // Index 2
    const PlaceholderScreen(title: 'Video', icon: Icons.ondemand_video), // Index 3
    const PlaceholderScreen(title: 'Menu Profil', icon: Icons.person), // Index 4: Placeholder saat dialog muncul
  ];

  void _onItemTapped(int index) async {
    // 1. Update State agar Warna Ikon Berubah (Termasuk Profil)
    setState(() {
      _selectedIndex = index;
    });

    // 2. Logika Khusus Jika Klik Profil (Index 4)
    if (index == 4) {
      // Tampilkan Dialog sesaat setelah ikon berubah warna
      await Future.delayed(const Duration(milliseconds: 100)); // Delay kecil agar UX halus
      
      if (!mounted) return;

      final result = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Menu Profil', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Lihat Profil"),
                onTap: () => Navigator.pop(ctx, "lihat"),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Keluar"),
                onTap: () => Navigator.pop(ctx, "logout"),
              ),
            ],
          ),
        ),
      );

      if (!mounted) return;

      // Navigasi berdasarkan pilihan dialog
      if (result == 'lihat') {
        Navigator.pushNamed(context, '/profil');
      } else if (result == 'logout') {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      
      // AppBar hanya muncul di Tab Beranda (Index 0)
      appBar: _selectedIndex == 0 ? AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        titleSpacing: 0,
        systemOverlayStyle: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding( // Tambahkan padding agar ikon tidak terlalu mepet kanan
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: theme.iconTheme.color, size: 24),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chat_rounded, color: theme.iconTheme.color, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ) : null, 

      // SafeArea menjaga agar konten tidak tertutup notch HP
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        backgroundColor: theme.cardColor, 
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        
        // Warna Item Aktif
        selectedItemColor: theme.colorScheme.primary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        
        // Warna Item Tidak Aktif
        unselectedItemColor: theme.disabledColor,
        showUnselectedLabels: true,
        
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Terlaris'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// === KONTEN BERANDA (DIPISAHKAN AGAR RAPI) ===
class _DashboardHomeContent extends StatelessWidget {
  const _DashboardHomeContent();

  final double maxContentWidth = 650.0;

  final List<Map<String, String>> testimoniList = const [
    {
      "nama": "Member 1",
      "komentar": "Pelayanan sangat ramah, mobil mantap dan proses cepat!",
    },
    {
      "nama": "Member 2",
      "komentar": "Harga bersahabat, servis showroom sangat direkomendasikan!",
    },
    {
      "nama": "Member 3",
      "komentar": "Unit sesuai iklan, lokasi mudah dijangkau.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Efek scroll membal
          padding: const EdgeInsets.only(bottom: 20, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. PROFIL SHOWROOM CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Margin kiri kanan lebih rapi
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Padding dalam card konsisten
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: const AssetImage('assets/images/showroom_logo.png'),
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          onBackgroundImageError: (_, __) {}, 
                          child: const Icon(Icons.store, color: Colors.transparent), 
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Showroom Mobil Bekas Jaya', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 18),
                                  const SizedBox(width: 3),
                                  Text('4.9', style: theme.textTheme.bodyMedium),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.verified_rounded, color: Colors.blue, size: 16),
                                  const SizedBox(width: 3),
                                  Text('1123 Member', style: theme.textTheme.bodySmall),
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
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.9),
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8), // Tombol sedikit lebih besar
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

              const SizedBox(height: 16), // Jarak antar section diperbesar sedikit

              // 2. AKSES CEPAT (SHORTCUTS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Text('Akses Cepat', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              // PERBAIKAN: Tinggi diperbesar ke 120 agar teks tidak terpotong
              SizedBox(
                height: 120, 
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    final cardW = (constraint.maxWidth < 500) ? 85.0 : 100.0; // Lebar card sedikit diperbesar
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12), // Padding listview kiri kanan
                      children: [
                        _ShortcutMenuItem(
                          icon: Icons.directions_car,
                          label: 'Mobil',
                          onTap: () => Navigator.pushNamed(context, '/katalog/list-mobil'),
                          width: cardW,
                        ),
                        _ShortcutMenuItem(
                          icon: Icons.extension,
                          label: 'Sparepart',
                          onTap: () => Navigator.pushNamed(context, '/sparepart/list'),
                          width: cardW,
                        ),
                        _ShortcutMenuItem(
                          icon: Icons.build,
                          label: 'Bengkel',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BengkelScreen()),
                          ),
                          width: cardW,
                        ),
                        _ShortcutMenuItem(
                          icon: Icons.verified,
                          label: 'Garansi',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const KlaimScreen()),
                          ),
                          width: cardW,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // 3. KESAN MEMBER (TESTIMONI)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: Text('Kesan Member', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              // PERBAIKAN: Tinggi diperbesar ke 140 agar muat 3 baris teks komentar
              SizedBox(
                height: 140, 
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    double width;
                    if (constraint.maxWidth < 440) {
                      width = 160;
                    } else if (constraint.maxWidth < 540) {
                      width = 180;
                    } else {
                      width = 210;
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: testimoniList.length,
                      itemBuilder: (context, i) {
                        final item = testimoniList[i];
                        return _TestimoniCard(
                          width: width,
                          nama: item['nama'] ?? '',
                          komentar: item['komentar'] ?? '',
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30), // Padding bawah agar tidak mentok navbar
            ],
          ),
        ),
      ),
    );
  }
}

// === WIDGET ITEM SHORTCUT ===
class _ShortcutMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;

  const _ShortcutMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding( // Tambahkan padding luar agar shadow card terlihat utuh
      padding: const EdgeInsets.only(right: 8, bottom: 4), 
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: theme.colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 1, // Memastikan hanya 1 baris
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === WIDGET CARD TESTIMONI ===
class _TestimoniCard extends StatelessWidget {
  final double width;
  final String nama;
  final String komentar;

  const _TestimoniCard({
    required this.width,
    required this.nama,
    required this.komentar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 410;
    final font = theme.textTheme.bodySmall?.copyWith(fontSize: isSmall ? 11 : 12);

    return SizedBox( // Bungkus Card dengan SizedBox agar constraints width dipatuhi
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: isSmall ? 11 : 13,
                    child: Icon(Icons.person,
                        size: isSmall ? 13 : 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nama,
                      style: font?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded( // Menggunakan Expanded agar teks mengisi sisa ruang
                child: Text(
                  '"$komentar"',
                  style: font?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 4, // Diperbanyak agar tidak terpotong
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}