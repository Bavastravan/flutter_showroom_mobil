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
  String _selectedStatus = 'all';

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

    if (_mobilIdController.text.trim().isEmpty ||
        _deskripsiController.text.trim().isEmpty) {
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

    var query = FirebaseFirestore.instance
        .collection('garansi')
        .where('userId', isEqualTo: user.uid);

    if (_selectedStatus != 'all') {
      query = query.where('status', isEqualTo: _selectedStatus);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klaim dan Cek Garansi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ajukan Klaim Garansi Mobil', style: AppTextStyles.heading2),
            const SizedBox(height: 14),

            // Input ID Mobil
            TextField(
  controller: _mobilIdController,
  decoration: InputDecoration(
    hintText: 'ID Mobil',
    prefixIcon: Icon(Icons.directions_car),
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // 🔧 ini penting
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color.fromARGB(255, 0, 0, 0),
  ),
),
            const SizedBox(height: 10),

           TextField(
  controller: _deskripsiController,
  minLines: 2,
  maxLines: 4,
  decoration: InputDecoration(
    hintText: 'Deskripsi Klaim',
    prefixIcon: Icon(Icons.description),
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color.fromARGB(255, 0, 0, 0),
  ),
),
            const SizedBox(height: 12),

            // Pesan error / sukses
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_successMessage != null)
              Text(_successMessage!, style: const TextStyle(color: Colors.green)),

            // Tombol submit klaim
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Ajukan Klaim'),
                onPressed: _isLoading ? null : _submitKlaim,
              ),
            ),

            const Divider(height: 32, thickness: 1),
            Text('Status Klaim Anda', style: AppTextStyles.heading3),
            const SizedBox(height: 8),

            // Filter klaim
            Row(
              children: [
                Text('Filter Status:', style: AppTextStyles.body2),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['all', 'pending', 'approved', 'rejected']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedStatus = val!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Daftar klaim
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _userKlaimsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada klaim garansi yang diajukan.',
                        style: AppTextStyles.body2,
                      ),
                    );
                  }

                  final klaims = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: klaims.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.directions_car,
                                      size: 30, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text('Mobil ID: $mobilId',
                                      style: AppTextStyles.heading3),
                                  const Spacer(),
                                  Icon(
                                    status == 'approved'
                                        ? Icons.check_circle
                                        : status == 'rejected'
                                            ? Icons.cancel
                                            : Icons.hourglass_top,
                                    color: status == 'approved'
                                        ? Colors.green
                                        : status == 'rejected'
                                            ? Colors.red
                                            : Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text('Deskripsi: $deskripsi',
                                  style: AppTextStyles.body2),
                              if (created != null)
                                Text(
                                  'Diajukan: ${created.day}-${created.month}-${created.year}',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
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