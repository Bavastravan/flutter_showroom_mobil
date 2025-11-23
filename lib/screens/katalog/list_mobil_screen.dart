import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mobil_model.dart';
import '../../widgets/mobil_card.dart';
import '../../themes/text_styles.dart';

class ListMobilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Katalog Mobil Bekas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mobils').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada mobil bekas tersedia', style: AppTextStyles.body2));
          }
          final mobils = snapshot.data!.docs
              .map((doc) => MobilModel.fromFirestore(doc))
              .toList();

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
    );
  }
}
