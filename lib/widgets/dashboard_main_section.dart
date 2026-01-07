import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardMainSection extends StatefulWidget {
  const DashboardMainSection({super.key});

  @override
  State<DashboardMainSection> createState() => _DashboardMainSectionState();
}

class _DashboardMainSectionState extends State<DashboardMainSection> with TickerProviderStateMixin {
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
          // SEARCH BAR + BACK + MORE
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 18, bottom: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Container(
                    height: 41,
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 20),
                        hintText: "Cari mobil, sparepart di showroom ...",
                        hintStyle: theme.textTheme.bodyMedium,
                        fillColor: theme.cardColor,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: theme.iconTheme.color, size: 26),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/showroom_logo.png'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Showroom Mobil Bekas Jaya', style: theme.textTheme.titleLarge),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text('4.9', style: theme.textTheme.bodyMedium),
                          SizedBox(width: 10),
                          Icon(Icons.verified, color: Colors.blue, size: 18),
                          Text('1123 Member', style: theme.textTheme.bodySmall),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: theme.colorScheme.primary, size: 18),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Pemasaran : Jl. Sukses Menuju Harapan, No. 3, Blok A, Indonesia',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.90),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share, color: theme.colorScheme.primary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          _DashboardTabView(tabIndex: tabIndex)
        ],
      ),
    );
  }
}

class _DashboardTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DashboardTabItem({required this.label, this.selected = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Column(
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: selected ? FontWeight.bold : null,
                  color: selected ? theme.colorScheme.primary : theme.textTheme.bodyMedium!.color,
                ),
              ),
              SizedBox(height: 2),
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

// Tab View Container, ANTI OVERFLOW via scroll
class _DashboardTabView extends StatelessWidget {
  final int tabIndex;
  const _DashboardTabView({required this.tabIndex});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (tabIndex) {
      case 0:
        return _ShowroomTabBody();
      case 1:
        return Center(child: Padding(
          padding: EdgeInsets.all(30),
          child: Text('Produk (fitur lanjut)', style: theme.textTheme.bodyLarge)));
      case 2:
        return Center(child: Padding(
          padding: EdgeInsets.all(30),
          child: Text('Kategori (fitur lanjut)', style: theme.textTheme.bodyLarge)));
      case 3:
        return Center(child: Padding(
          padding: EdgeInsets.all(30),
          child: Text('Live (fitur lanjut)', style: theme.textTheme.bodyLarge)));
      default:
        return SizedBox.shrink();
    }
  }
}

// Showroom Body: scrollable, grid anti overflow
class _ShowroomTabBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Semua Mobil', style: theme.textTheme.titleMedium),
          SizedBox(height: 10),
          SizedBox(
            height: 250, // atur sesuai grid
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('mobils').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Text('Belum ada data mobil', style: theme.textTheme.bodySmall);

                final docs = snapshot.data!.docs;
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 480 ? 2 : 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.76,
                  ),
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    return _ProductCard(
                      imageUrl: data['gambarUrl'] ?? '',
                      title: data['nama'] ?? '-',
                      subtitle: data['merk'] ?? '',
                      price: data['harga'] ?? 0,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 18),
          Text('Semua Sparepart', style: theme.textTheme.titleMedium),
          SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('spareparts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Text('Belum ada sparepart', style: theme.textTheme.bodySmall);

                final docs = snapshot.data!.docs;
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 480 ? 2 : 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.86,
                  ),
                  itemBuilder: (context, i) {
                    final data = docs[i].data();
                    return _ProductCard(
                      imageUrl: data['gambarUrl'] ?? '',
                      title: data['nama'] ?? '-',
                      subtitle: data['merk'] ?? '',
                      price: data['harga'] ?? 0,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 18),
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
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {}, // TODO: Navigasi ke detail mobil/sparepart
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 100, color: theme.dividerColor, child: Icon(Icons.image, size: 48)),
                    )
                  : Container(height: 100, color: theme.dividerColor, child: Icon(Icons.image, size: 48)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
              child: Text(title, style: theme.textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(subtitle, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Rp${price.toString()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary, fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
