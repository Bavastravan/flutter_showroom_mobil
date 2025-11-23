import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sparepart_model.dart';
import '../../widgets/sparepart_card.dart';
import '../../themes/text_styles.dart';

class ListSparepartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Sparepart'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('spareparts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: AppTextStyles.body2));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Sparepart belum tersedia', style: AppTextStyles.body2),
            );
          }

          final spareparts = snapshot.data!.docs
              .map((doc) => SparepartModel.fromFirestore(doc))
              .toList();

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
                    arguments: sparepart, // kirim seluruh data, atau id saja jika prefer
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/sparepart/edit'); // route ke form tambah/edit
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Sparepart Baru',
      ),
    );
  }
}
