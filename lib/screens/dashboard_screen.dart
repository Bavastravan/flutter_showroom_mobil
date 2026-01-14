import 'package:flutter/material.dart';
import '../widgets/dashboard_main_section.dart';
import 'bengkel_screen.dart';
import 'garansi/klaim_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final double maxContentWidth = 650.0;

  final List<Map<String, String>> testimoniList = [
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
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerRight,
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // PROFIL SHOWROOM
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                Text('Showroom Mobil Bekas Jaya', style: theme.textTheme.titleLarge),
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
                                          horizontal: 14, vertical: 7),
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

                const SizedBox(height: 12),

                // AKSES CEPAT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  child: Text('Akses Cepat', style: theme.textTheme.titleMedium),
                ),
                SizedBox(
                  height: 100,
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      final cardW = (constraint.maxWidth < 500) ? 80.0 : 95.0;
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16, right: 6),
                        children: [
                          _ShortcutMenuItem(
                            icon: Icons.directions_car,
                            label: 'Mobil',
                            onTap: () =>
                                Navigator.pushNamed(context, '/katalog/list-mobil'),
                            width: cardW,
                          ),
                          _ShortcutMenuItem(
                            icon: Icons.extension,
                            label: 'Sparepart',
                            onTap: () =>
                                Navigator.pushNamed(context, '/sparepart/list'),
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

                // KESAN MEMBER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                  child: Text('Kesan Member', style: theme.textTheme.titleMedium),
                ),
                SizedBox(
                  height: 100,
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      double width;
                      if (constraint.maxWidth < 440) {
                        width = 152;
                      } else if (constraint.maxWidth < 540) {
                        width = 175;
                      } else {
                        width = 205;
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const _DashboardBottomBar(),
    );
  }
}

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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 26, color: theme.colorScheme.primary),
                const SizedBox(height: 7),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    final font = theme.textTheme.bodySmall?.copyWith(fontSize: isSmall ? 11 : null);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    radius: isSmall ? 11 : 13,
                    child: Icon(Icons.person,
                        size: isSmall ? 13 : 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nama,
                      style: font,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 4 : 7),
              Expanded(
                child: Text(
                  '"$komentar"',
                  style: font,
                  maxLines: isSmall ? 2 : 3,
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

class _DashboardBottomBar extends StatefulWidget {
  const _DashboardBottomBar();

  @override
  State<_DashboardBottomBar> createState() => _DashboardBottomBarState();
}

class _DashboardBottomBarState extends State<_DashboardBottomBar> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.disabledColor,
      currentIndex: _selected,
      onTap: (i) async {
        setState(() => _selected = i);
        if (i == 4) {
          final res = await showDialog<String>(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
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
          if (res == 'lihat') {
            Navigator.pushNamed(context, '/profil');
          } else if (res == 'logout') {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Terlaris'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
        BottomNavigationBarItem(icon: Icon(Icons.ondemand_video), label: 'Video'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
