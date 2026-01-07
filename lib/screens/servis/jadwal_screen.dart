import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/text_styles.dart';

class JadwalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Servis Mobil'),
      ),
      body: user == null
          ? Center(
              child: Text(
                'Anda harus login untuk melihat jadwal servis.',
                style: AppTextStyles.body2,
              ),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('servis')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('tanggal', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada jadwal servis yang anda booking.',
                      style: AppTextStyles.body2,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final jadwalList = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: jadwalList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final jadwal = jadwalList[index];
                    final tgl = (jadwal['tanggal'] as Timestamp).toDate();
                    final status = jadwal['status'] ?? 'pending';

                    return Card(
                      child: ListTile(
                        title: Text('Servis Mobil', style: AppTextStyles.heading3),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal: ${tgl.day}-${tgl.month}-${tgl.year}', style: AppTextStyles.body1),
                            SizedBox(height: 6),
                            Text('Status: $status', style: AppTextStyles.body2),
                          ],
                        ),
                        trailing: Icon(Icons.car_repair),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/servis/booking');
        },
        child: Icon(Icons.add),
        tooltip: 'Booking Servis',
      ),
    );
  }
}
