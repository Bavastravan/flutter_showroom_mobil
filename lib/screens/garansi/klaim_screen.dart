import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/text_styles.dart';

class KlaimScreen extends StatefulWidget {
  @override
  State<KlaimScreen> createState() => _KlaimScreenState();
}

class _KlaimScreenState extends State<KlaimScreen> {
  final _mobilIdController = TextEditingController();
  final _deskripsiController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage, _successMessage;

  // Submit pengajuan klaim garansi
  Future<void> _submitKlaim() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = 'Anda harus login terlebih dahulu.';
        _isLoading = false;
      });
      return;
    }
    if (_mobilIdController.text.trim().isEmpty || _deskripsiController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi semua data!';
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('garansi').add({
        'userId': user.uid,
        'mobilId': _mobilIdController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _successMessage = 'Klaim berhasil diajukan!';
        _mobilIdController.clear();
        _deskripsiController.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengajukan klaim, coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load semua klaim user dari Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> _userKlaimsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('garansi')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Klaim dan Cek Garansi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ajukan Klaim Garansi Mobil', style: AppTextStyles.heading2),
            SizedBox(height: 14),
            TextField(
              controller: _mobilIdController,
              decoration: InputDecoration(
                labelText: 'ID Mobil',
                hintText: 'Masukkan ID mobil yang ingin diklaim',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _deskripsiController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Deskripsi Klaim',
                hintText: 'Jelaskan masalah pada mobil anda',
              ),
            ),
            SizedBox(height: 12),
            if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_successMessage != null) Text(_successMessage!, style: TextStyle(color: Colors.green)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.send),
                label: Text('Ajukan Klaim'),
                onPressed: _isLoading ? null : _submitKlaim,
              ),
            ),
            Divider(height: 32, thickness: 1),
            Text('Status Klaim Anda', style: AppTextStyles.heading3),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _userKlaimsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada klaim garansi yang diajukan.', style: AppTextStyles.body2));
                  }

                  final klaims = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: klaims.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final klaim = klaims[index];
                      final status = klaim['status'] ?? 'pending';
                      final deskripsi = klaim['deskripsi'] ?? '';
                      final mobilId = klaim['mobilId'] ?? '';
                      DateTime? created;
                      if (klaim['createdAt'] != null) {
                        created = (klaim['createdAt'] as Timestamp).toDate();
                      }
                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: Text('Mobil ID: $mobilId'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Deskripsi: $deskripsi', style: AppTextStyles.body2),
                              SizedBox(height: 8),
                              Text('Status: $status', style: TextStyle(fontWeight: FontWeight.bold)),
                              if (created != null)
                                Text('Diajukan: ${created.day}-${created.month}-${created.year}', style: AppTextStyles.body2),
                            ],
                          ),
                          leading: Icon(Icons.verified, color: status == 'approved' ? Colors.green : Colors.orange),
                        ),
                      );
                    },
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
