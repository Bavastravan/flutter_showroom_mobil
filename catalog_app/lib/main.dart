import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Produk',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const ProdukPage(),
    const FavoritePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ===============================
// 🏠 HALAMAN PRODUK (HOME PAGE)
// ===============================

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final List<Map<String, dynamic>> produkList = [
    {
      'nama': 'Laptop Gaming',
      'harga': 15999000,
      'gambar': 'https://picsum.photos/400/300?random=1',
    },
    {
      'nama': 'Headphone Premium',
      'harga': 899000,
      'gambar': 'https://picsum.photos/400/300?random=2',
    },
    {
      'nama': 'Smartwatch Elegan',
      'harga': 1200000,
      'gambar': 'https://picsum.photos/400/300?random=3',
    },
    {
      'nama': 'Kamera Mirrorless',
      'harga': 8500000,
      'gambar': 'https://picsum.photos/400/300?random=4',
    },
    {
      'nama': 'Keyboard Mechanical',
      'harga': 750000,
      'gambar': 'https://picsum.photos/400/300?random=5',
    },
    {
      'nama': 'Mouse Wireless',
      'harga': 250000,
      'gambar': 'https://picsum.photos/400/300?random=6',
    },
  ];

  final List<String> sliderImages = [
    'https://picsum.photos/800/300?random=10',
    'https://picsum.photos/800/300?random=11',
    'https://picsum.photos/800/300?random=12',
    'https://picsum.photos/800/300?random=13',
    'https://picsum.photos/800/300?random=14',
  ];

  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  late final PageController _pageController;
  int _currentPage = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 4)).then((_) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % sliderImages.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _autoSlide();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProdukList = produkList.where((produk) {
      return produk['nama'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍 Katalog Produk'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🖼 Slider Gambar
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: sliderImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          sliderImages[index],
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 100),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        sliderImages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Cari produk...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🛒 Grid Produk
            Expanded(
              child: GridView.builder(
                itemCount: filteredProdukList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final produk = filteredProdukList[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.network(
                            produk['gambar'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 80),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk['nama'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currencyFormat.format(produk['harga']),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Kamu membeli ${produk['nama']}!'),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Beli Sekarang"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// ❤ HALAMAN FAVORIT
// ===============================
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Map<String, dynamic>> favoriteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤ Favorit'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: favoriteList.isEmpty
          ? const Center(child: Text("Belum ada produk favorit"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final produk = favoriteList[index];
                return ListTile(
                  leading: Image.network(
                    produk['gambar'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(produk['nama']),
                  subtitle: Text(NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(produk['harga'])),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        favoriteList.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ===============================
// 🛒 HALAMAN KERANJANG
// ===============================
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Keranjang'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: cartList.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final produk = cartList[index];
                return ListTile(
                  leading: Image.network(
                    produk['gambar'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(produk['nama']),
                  subtitle: Text(NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(produk['harga'])),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        cartList.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ===============================
// 👤 HALAMAN PROFIL
// ===============================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Profil'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            Text(
              "Nama Pengguna",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("email@contoh.com"),
          ],
        ),
      ),
    );
  }
}