import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/mobil_model.dart';

class PesanMobilScreen extends StatefulWidget {
  const PesanMobilScreen({Key? key}) : super(key: key);

  @override
  State<PesanMobilScreen> createState() => _PesanMobilScreenState();
}

class _PesanMobilScreenState extends State<PesanMobilScreen> {
  final TextEditingController _catatanController = TextEditingController();
  
  // State Variables
  String _selectedPaymentMethod = 'BCA Virtual Account';
  int _quantity = 1; // Default jumlah pembelian 1
  int _selectedShippingIndex = 0; // Default: Ambil Sendiri
  bool _isLoading = false;

  // Data Dummy Opsi Pengiriman
  final List<Map<String, dynamic>> _shippingOptions = [
    {'name': 'Ambil Sendiri di Showroom', 'price': 0, 'desc': 'Gratis'},
    {'name': 'Towing (Dalam Kota)', 'price': 500000, 'desc': 'Estimasi 1 Hari'},
    {'name': 'Towing (Luar Kota)', 'price': 1500000, 'desc': 'Estimasi 2-3 Hari'},
  ];

  // Data Dummy User
  final String _userAddress =
      "Jl. Merpati Putih No. 45, Kel. Sukamaju, Kec. Cilodong, Kota Depok, Jawa Barat, 16415";
  final String _userName = "Budi Santoso";
  final String _userPhone = "0812-3456-7890";

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _updateQuantity(int delta) {
    setState(() {
      int newQty = _quantity + delta;
      if (newQty >= 1) { // Minimal 1
        _quantity = newQty;
      }
    });
  }

  Future<void> _processBooking(MobilModel mobil, double totalBayar) async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 10),
              const Text("Pesanan Berhasil!"),
            ],
          ),
          content: Text(
            "Anda memesan $_quantity unit ${mobil.nama}.\nTotal: ${currencyFormatter.format(totalBayar)}\n\nSilakan cek email untuk instruksi pembayaran.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false);
              },
              child: const Text("OK, Kembali ke Beranda"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! String) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Data tidak valid")),
      );
    }
    final String mobilId = args;

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full sampai atas
      appBar: AppBar(
        title: const Text("Pengiriman / Checkout"),
        centerTitle: true,
        backgroundColor: colorScheme.surface.withOpacity(0.8), // Efek kaca
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('mobils').doc(mobilId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data mobil tidak ditemukan"));
          }

          final mobil = MobilModel.fromFirestore(snapshot.data!);

          // --- LOGIKA KALKULASI HARGA ---
          final double hargaSatuan = mobil.harga.toDouble();
          final double subTotalMobil = hargaSatuan * _quantity;
          final double biayaAdmin = 5000000;
          final double biayaKirim = _shippingOptions[_selectedShippingIndex]['price'].toDouble();
          final double totalBayar = subTotalMobil + biayaAdmin + biayaKirim;

          return Container(
            // --- BACKGROUND GRADIENT ---
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                    : [const Color(0xFFF5F7FA), const Color(0xFFE4E9F2)],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final contentWidth = isWide ? 600.0 : double.infinity;

                  return Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. ALAMAT
                                  _buildSectionLabel(theme, "Alamat Pengiriman"),
                                  _buildAddressCard(theme, colorScheme),
                                  const SizedBox(height: 20),

                                  // 2. ITEM & QUANTITY
                                  _buildSectionLabel(theme, "Detail Pesanan"),
                                  _buildItemCard(theme, colorScheme, mobil),
                                  const SizedBox(height: 20),

                                  // 3. OPSI PENGIRIMAN
                                  _buildSectionLabel(theme, "Metode Pengiriman"),
                                  _buildShippingSelector(theme, colorScheme),
                                  const SizedBox(height: 20),

                                  // 4. METODE PEMBAYARAN
                                  _buildSectionLabel(theme, "Metode Pembayaran"),
                                  _buildPaymentMethodSelector(theme, colorScheme),
                                  const SizedBox(height: 20),

                                  // 5. RINGKASAN
                                  _buildSectionLabel(theme, "Ringkasan Belanja"),
                                  _buildSummaryCard(
                                    theme, 
                                    colorScheme,
                                    subTotalMobil, 
                                    biayaAdmin, 
                                    biayaKirim, 
                                    totalBayar
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          // BOTTOM BAR
                          _buildBottomBar(theme, colorScheme, totalBayar, mobil),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= WIDGET COMPONENTS =================

  Widget _buildSectionLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildCardBase({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  Widget _buildAddressCard(ThemeData theme, ColorScheme colorScheme) {
    return _buildCardBase(
      theme: theme,
      colorScheme: colorScheme,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Alamat Utama",
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {}, // TODO: Ganti Alamat
                  child: Text("Ubah", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
            const SizedBox(height: 4),
            Text(
              "$_userName ($_userPhone)",
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _userAddress,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(ThemeData theme, ColorScheme colorScheme, MobilModel mobil) {
    final bool isNetwork = mobil.gambarUrl.startsWith('http');

    return _buildCardBase(
      theme: theme,
      colorScheme: colorScheme,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: isNetwork
                        ? Image.network(mobil.gambarUrl, fit: BoxFit.cover)
                        : Image.asset(mobil.gambarUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mobil.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${mobil.merk} • ${mobil.tahun}",
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormatter.format(mobil.harga),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // --- FITUR JUMLAH PEMBELIAN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jumlah Unit", style: theme.textTheme.bodyMedium),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => _updateQuantity(-1),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => _updateQuantity(1),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Catatan
            TextField(
              controller: _catatanController,
              decoration: InputDecoration(
                hintText: "Catatan untuk penjual...",
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                isDense: true,
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET OPSI PENGIRIMAN ---
  Widget _buildShippingSelector(ThemeData theme, ColorScheme colorScheme) {
    return _buildCardBase(
      theme: theme,
      colorScheme: colorScheme,
      child: Column(
        children: List.generate(_shippingOptions.length, (index) {
          final option = _shippingOptions[index];
          final isSelected = _selectedShippingIndex == index;
          
          return Column(
            children: [
              RadioListTile<int>(
                value: index,
                groupValue: _selectedShippingIndex,
                onChanged: (val) => setState(() => _selectedShippingIndex = val!),
                activeColor: colorScheme.primary,
                title: Text(
                  option['name'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(option['desc'], style: theme.textTheme.bodySmall),
                secondary: Text(
                  option['price'] == 0 ? "FREE" : currencyFormatter.format(option['price']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: option['price'] == 0 ? Colors.green : colorScheme.onSurface,
                    fontSize: 12,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (index != _shippingOptions.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16, color: colorScheme.outlineVariant.withOpacity(0.3)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(ThemeData theme, ColorScheme colorScheme) {
    final methods = [
      {'name': 'BCA Virtual Account', 'icon': Icons.account_balance_wallet},
      {'name': 'Mandiri Virtual Account', 'icon': Icons.account_balance},
      {'name': 'Kartu Kredit / Debit', 'icon': Icons.credit_card},
    ];

    return _buildCardBase(
      theme: theme,
      colorScheme: colorScheme,
      child: Column(
        children: methods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          final isSelected = _selectedPaymentMethod == method['name'];

          return Column(
            children: [
              RadioListTile<String>(
                value: method['name'] as String,
                groupValue: _selectedPaymentMethod,
                onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                title: Text(
                  method['name'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                secondary: Icon(method['icon'] as IconData, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
                activeColor: colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (index != methods.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16, color: colorScheme.outlineVariant.withOpacity(0.3)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, ColorScheme colorScheme, double subtotal, double admin, double kirim, double total) {
    return _buildCardBase(
      theme: theme,
      colorScheme: colorScheme,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSummaryRow(theme, "Subtotal ($_quantity unit)", subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow(theme, "Biaya Pengiriman", kirim),
            const SizedBox(height: 8),
            _buildSummaryRow(theme, "Biaya Layanan/Admin", admin),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              // --- PERBAIKAN: Menghapus style: BorderStyle.solid ---
              child: Divider(color: colorScheme.outlineVariant, thickness: 1), 
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Tagihan", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  currencyFormatter.format(total),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(currencyFormatter.format(value), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme, ColorScheme colorScheme, double totalBayar, MobilModel mobil) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total Pembayaran", style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currencyFormatter.format(totalBayar),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _processBooking(mobil, totalBayar),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: colorScheme.primary.withOpacity(0.4),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2),
                      )
                    : const Text("Bayar Sekarang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}