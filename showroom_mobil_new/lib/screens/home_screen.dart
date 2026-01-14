import 'package:flutter/material.dart';
import '../models/mobil_model.dart';
import 'mobil_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyCars = [
      MobilModel(
        id: 1,
        namaMobil: 'Toyota Avanza',
        merk: 'Toyota',
        tahun: 2018,
        harga: 150000000,
        transmisi: 'matic',
        bahanBakar: 'bensin',
        status: 'ready',
      ),
      MobilModel(
        id: 2,
        namaMobil: 'Honda Jazz',
        merk: 'Honda',
        tahun: 2017,
        harga: 175000000,
        transmisi: 'manual',
        bahanBakar: 'bensin',
        status: 'ready',
      ),
      // tambahkan lainnya kalau mau
    ];

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Showroom'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyCars.length,
        itemBuilder: (context, index) {
          final car = dummyCars[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.directions_car_filled),
              title: Text(
                car.namaMobil,
                style: textTheme.titleMedium,
              ),
              subtitle: Text(
                'Tahun ${car.tahun} • Rp ${car.harga}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MobilDetailScreen(mobil: car),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
