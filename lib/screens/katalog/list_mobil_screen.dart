import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mobil_model.dart';
import '../../widgets/mobil_card.dart';
import '../../themes/text_styles.dart';

class ListMobilScreen extends StatefulWidget {
  const ListMobilScreen({Key? key}) : super(key: key);

  @override
  State<ListMobilScreen> createState() => _ListMobilScreenState();
}

class _ListMobilScreenState extends State<ListMobilScreen> {
  String _search = '';
  double _minRating = 0;
  int? _minHarga;
  int? _maxHarga;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Katalog Mobil Bekas'),
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
                      hintText: "Cari mobil ...",
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
          // === Daftar Mobil ===
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('mobils').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Center(child: Text('Tidak ada mobil bekas tersedia', style: AppTextStyles.body2));

                final mobils = snapshot.data!.docs
                    .map((doc) => MobilModel.fromFirestore(doc))
                    .where((mobil) =>
                        (_search.isEmpty ||
                            mobil.nama.toLowerCase().contains(_search.toLowerCase()) ||
                            mobil.merk.toLowerCase().contains(_search.toLowerCase())) &&
                        (mobil.rating ?? 0) >= _minRating &&
                        (_minHarga == null || mobil.harga >= _minHarga!) &&
                        (_maxHarga == null || mobil.harga <= _maxHarga!))
                    .toList();

                if (mobils.isEmpty)
                  return Center(
                    child: Text('Mobil dengan filter tersebut tidak ditemukan.', style: AppTextStyles.body2),
                  );

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: mobils.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final mobil = mobils[index];
                    return MobilCard(
                      mobil: mobil,
                      onTap: () {
                        Navigator.pushNamed(context, '/katalog/detail-mobil', arguments: mobil.id);
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
    final theme = Theme.of(context);
    final _hargaControllerMin = TextEditingController(text: _minHarga?.toString() ?? '');
    final _hargaControllerMax = TextEditingController(text: _maxHarga?.toString() ?? '');

    double tempRating = _minRating;
    int? tempMinHarga = _minHarga;
    int? tempMaxHarga = _maxHarga;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Filter Pilihan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Flexible(
                    child: TextField(
                      controller: _hargaControllerMin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Harga min'),
                      onChanged: (val) => tempMinHarga = int.tryParse(val),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: TextField(
                      controller: _hargaControllerMax,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Harga max'),
                      onChanged: (val) => tempMaxHarga = int.tryParse(val),
                    ),
                  ),
                ]),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Minimal Rating: ${tempRating.toStringAsFixed(1)}'),
                    Expanded(
                      child: Slider(
                        value: tempRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        label: tempRating.toStringAsFixed(1),
                        onChanged: (v) => setState(() {
                          tempRating = v;
                        }),
                        activeColor: theme.colorScheme.primary,
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
              child: Text('Terapkan'),
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
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
