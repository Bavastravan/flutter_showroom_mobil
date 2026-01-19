import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk TextInputFormatter & SystemUiOverlayStyle
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/sparepart_model.dart'; 

class ListSparepartScreen extends StatefulWidget {
  const ListSparepartScreen({Key? key}) : super(key: key);

  @override
  State<ListSparepartScreen> createState() => _ListSparepartScreenState();
}

class _ListSparepartScreenState extends State<ListSparepartScreen> {
  // Controller search
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  // Filter State
  double _minRating = 0;
  int? _minHarga;
  int? _maxHarga;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // === LOGIKA WARNA HEADER DINAMIS ===
    final Color headerBgColor = isDarkMode 
        ? const Color(0xFF0D1B2A)  // Biru Tua Gelap
        : const Color(0xFFE3F2FD); // Biru Muda Soft
        
    final Color headerFgColor = isDarkMode 
        ? Colors.white             // Teks Putih
        : const Color(0xFF1565C0); // Teks Biru Tua

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Katalog Sparepart',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: headerFgColor, 
          ),
        ),
        backgroundColor: headerBgColor, 
        foregroundColor: headerFgColor, 
        elevation: 0,
        
        systemOverlayStyle: isDarkMode 
            ? SystemUiOverlayStyle.light 
            : SystemUiOverlayStyle.dark,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // === 1. Search Bar ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _search = val),
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        hintText: "Cari sparepart...",
                        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: _search.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _search = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _showFilterDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.tune, color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),

          // === 2. List Sparepart ===
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('spareparts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category_outlined, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text('Belum ada data sparepart', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                // === LOGIKA FILTER ===
                final spareparts = snapshot.data!.docs.map((doc) {
                  return SparepartModel.fromFirestore(doc);
                }).where((item) {
                  bool matchSearch = true;
                  if (_search.isNotEmpty) {
                    final s = _search.toLowerCase();
                    matchSearch = item.nama.toLowerCase().contains(s) || 
                                  item.merk.toLowerCase().contains(s);
                  }
                  bool matchRating = (item.rating ?? 0.0) >= _minRating;
                  bool matchMinPrice = true;
                  if (_minHarga != null && _minHarga! > 0) {
                    matchMinPrice = item.harga >= _minHarga!;
                  }
                  bool matchMaxPrice = true;
                  if (_maxHarga != null && _maxHarga! > 0) {
                    matchMaxPrice = item.harga <= _maxHarga!;
                  }
                  return matchSearch && matchRating && matchMinPrice && matchMaxPrice;
                }).toList();

                if (spareparts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text('Sparepart tidak ditemukan', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: spareparts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = spareparts[index];
                    return SparepartCard(
                      sparepart: item,
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          '/sparepart/detail', 
                          arguments: item.id
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // === FILTER DIALOG ===
  void _showFilterDialog() {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.decimalPattern('id');

    final minController = TextEditingController(
      text: (_minHarga != null && _minHarga! > 0) ? currencyFormat.format(_minHarga) : ''
    );
    final maxController = TextEditingController(
      text: (_maxHarga != null && _maxHarga! > 0) ? currencyFormat.format(_maxHarga) : ''
    );

    double tempRating = _minRating;
    int? tempMinHarga = _minHarga;
    int? tempMaxHarga = _maxHarga;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Center(child: Text('Filter Pencarian', style: TextStyle(fontWeight: FontWeight.bold))),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rentang Harga (Rp)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCurrencyInput(theme, 'Min', minController, (val) {
                            tempMinHarga = val;
                          }),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: _buildCurrencyInput(theme, 'Max', maxController, (val) {
                            tempMaxHarga = val;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Min Rating', style: TextStyle(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            Text(' ${tempRating.toStringAsFixed(1)}+', 
                              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Slider(
                      value: tempRating,
                      min: 0, max: 5, divisions: 10,
                      label: tempRating.toStringAsFixed(1),
                      activeColor: theme.colorScheme.primary,
                      onChanged: (v) => setDialogState(() => tempRating = v),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _minRating = 0;
                            _minHarga = null;
                            _maxHarga = null;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minRating = tempRating;
                            _minHarga = tempMinHarga;
                            _maxHarga = tempMaxHarga;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: const Text('Terapkan'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencyInput(ThemeData theme, String label, TextEditingController controller, Function(int?) onChanged) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [ CurrencyInputFormatter() ], 
      onChanged: (val) {
        String cleanVal = val.replaceAll('.', '');
        if (cleanVal.isEmpty) {
          onChanged(null);
        } else {
          onChanged(int.tryParse(cleanVal));
        }
      },
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        prefixText: 'Rp ',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ==========================================
// SPAREPART CARD (UPDATED)
// ==========================================
class SparepartCard extends StatelessWidget {
  final SparepartModel sparepart;
  final VoidCallback onTap;

  const SparepartCard({
    Key? key,
    required this.sparepart,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // PERBAIKAN 1: Format Rupiah dengan Titik (Rp 120.000)
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );
    
    bool isNetworkImage = sparepart.gambarUrl.startsWith('http');

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Kecil
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 110, height: 90,
                  color: Colors.grey[200],
                  child: isNetworkImage
                      ? Image.network(
                          sparepart.gambarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Image.asset(
                          sparepart.gambarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nama
                    Text(
                      sparepart.nama,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Merk
                    Text(
                      sparepart.merk,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // PERBAIKAN 2: Rating & Terjual DIATAS Harga
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          (sparepart.rating ?? 4.5).toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Container(width: 1, height: 12, color: Colors.grey[300]),
                        const SizedBox(width: 8),
                        Text(
                          "Terjual 24", // Dummy data terjual
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // PERBAIKAN 3: Harga (Format Rupiah Benar)
                    Text(
                      currencyFormatter.format(sparepart.harga),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
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
}

// ==========================================
// FORMATTER RIBUAN (AUTO DOTS)
// ==========================================
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if(newValue.text.contains(RegExp(r'[^\d.]'))) {
        return oldValue; 
    }

    String cleanText = newValue.text.replaceAll('.', '');
    if (cleanText.isEmpty) return newValue.copyWith(text: '');

    int value = int.parse(cleanText);
    final formatter = NumberFormat('#,###', 'id');
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}