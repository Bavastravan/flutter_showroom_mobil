import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sparepart_model.dart';
import '../../widgets/sparepart_card.dart';
import '../../themes/text_styles.dart';

class ListSparepartScreen extends StatefulWidget {
  const ListSparepartScreen({Key? key}) : super(key: key);

  @override
  State<ListSparepartScreen> createState() => _ListSparepartScreenState();
}

class _ListSparepartScreenState extends State<ListSparepartScreen> {
  String _search = '';
  double _minRating = 0;
  int? _minHarga;
  int? _maxHarga;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Sparepart'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // === Search & Filter ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _search = val),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Cari sparepart ...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: theme.cardColor,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.tune, color: theme.colorScheme.primary),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter',
                ),
              ],
            ),
          ),
          // === Daftar Sparepart ===
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('spareparts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('Terjadi error: ${snapshot.error}', style: AppTextStyles.body2));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Center(child: Text('Sparepart belum tersedia', style: AppTextStyles.body2));

                final spareparts = snapshot.data!.docs
                    .map((doc) => SparepartModel.fromFirestore(doc))
                    .where((sparepart) =>
                        (_search.isEmpty ||
                            sparepart.nama.toLowerCase().contains(_search.toLowerCase()) ||
                            sparepart.merk.toLowerCase().contains(_search.toLowerCase())) &&
                        (sparepart.rating ?? 0) >= _minRating &&
                        (_minHarga == null || sparepart.harga >= _minHarga!) &&
                        (_maxHarga == null || sparepart.harga <= _maxHarga!))
                    .toList();

                if (spareparts.isEmpty)
                  return Center(child: Text('Sparepart dengan filter tersebut tidak ditemukan.', style: AppTextStyles.body2));

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: spareparts.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final sparepart = spareparts[index];
                    return SparepartCard(
                      sparepart: sparepart,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/sparepart/detail',
                          arguments: sparepart.id, // harus id bertipe String!
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

  void _showFilterDialog() async {
  final theme = Theme.of(context); // gunakan jika akan dipakai!
  final _hargaControllerMin = TextEditingController(text: _minHarga?.toString() ?? '');
  final _hargaControllerMax = TextEditingController(text: _maxHarga?.toString() ?? '');

  double tempRating = _minRating;
  int? tempMinHarga = _minHarga;
  int? tempMaxHarga = _maxHarga;

  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text('Filter Pilihan', style: theme.textTheme.titleLarge), // contoh penggunaan theme
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Flexible(
                  child: TextField(
                    controller: _hargaControllerMin,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga min',
                      labelStyle: theme.textTheme.bodySmall, // contoh pakai theme
                      // dst ...
                    ),
                    onChanged: (val) => tempMinHarga = int.tryParse(val),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _hargaControllerMax,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga max',
                      labelStyle: theme.textTheme.bodySmall,
                    ),
                    onChanged: (val) => tempMaxHarga = int.tryParse(val),
                  ),
                ),
              ]),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Minimal Rating: ${tempRating.toStringAsFixed(1)}', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: Slider(
                      value: tempRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: tempRating.toStringAsFixed(1),
                      activeColor: theme.colorScheme.primary, // contoh memakai theme color
                      onChanged: (v) => setState(() {
                        tempRating = v;
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _minRating = tempRating;
                _minHarga = tempMinHarga;
                _maxHarga = tempMaxHarga;
              });
              Navigator.pop(context);
            },
            child: Text('Terapkan', style: theme.textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _minRating = 0;
                _minHarga = null;
                _maxHarga = null;
              });
              Navigator.pop(context);
            },
            child: Text('Reset', style: theme.textTheme.labelLarge),
          ),
        ],
      );
    },
  );
}
}
