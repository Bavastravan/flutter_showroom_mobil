import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/text_styles.dart';

class KlaimScreen extends StatefulWidget {
  const KlaimScreen({super.key});

  @override
  State<KlaimScreen> createState() => _KlaimScreenState();
}

class _KlaimScreenState extends State<KlaimScreen> {
  final _platController = TextEditingController();
  final _noRangkaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool _isLoading = false;
  bool _setuju = false;
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

    if (_platController.text.trim().isEmpty ||
        _noRangkaController.text.trim().isEmpty ||
        _deskripsiController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi semua data!';
        _isLoading = false;
      });
      return;
    }

    if (!_setuju) {
      setState(() {
        _errorMessage = 'Anda harus menyetujui syarat & ketentuan.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Cek duplikasi klaim plat + user
      final snapshot = await FirebaseFirestore.instance
          .collection('garansi')
          .where('userId', isEqualTo: user.uid)
          .where('plat', isEqualTo: _platController.text.trim())
          .where('status', isEqualTo: 'pending')
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _errorMessage = 'Anda sudah pernah mengajukan klaim dengan plat ini, silakan cek status.';
          _isLoading = false;
        });
        return;
      }

      await FirebaseFirestore.instance.collection('garansi').add({
        'userId': user.uid,
        'plat': _platController.text.trim(),
        'noRangka': _noRangkaController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _successMessage = 'Klaim berhasil diajukan! Proses verifikasi maksimal 2x24 jam.';
        _platController.clear();
        _noRangkaController.clear();
        _deskripsiController.clear();
        _setuju = false;
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan & Cek Klaim Garansi'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: ListView(
          children: [
            Text('Formulir Klaim Garansi Resmi Showroom', style: AppTextStyles.heading2),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 22),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Klaim hanya bisa diajukan untuk kendaraan yang terdaftar sebagai pembelian resmi showroom. Proses maksimal 2x24 jam!',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // No Polisi/Plat Nomor (WAJIB)
            TextField(
              controller: _platController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Nomor Polisi (Plat, contoh: B 1234 XYZ)',
                prefixIcon: Icon(Icons.confirmation_number),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),

            // No Rangka (WAJIB)
            TextField(
              controller: _noRangkaController,
              decoration: InputDecoration(
                hintText: 'Nomor Rangka Kendaraan',
                prefixIcon: Icon(Icons.directions_car),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),

            // Deskripsi keluhan/gangguan
            TextField(
              controller: _deskripsiController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Deskripsi kerusakan / keluhan untuk klaim garansi',
                prefixIcon: Icon(Icons.description),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),

            const SizedBox(height: 10),

            // Persetujuan Syarat & Ketentuan
            Row(
              children: [
                Checkbox(
                  value: _setuju,
                  onChanged: (v) => setState(() => _setuju = v ?? false),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () => setState(() => _setuju = !_setuju),
                    child: Text(
                      'Saya menyatakan data yang saya isi BENAR dan bersedia mengikuti ketentuan klaim showroom.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Pesan error / sukses
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(_successMessage!, style: const TextStyle(color: Colors.green)),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.shield),
                label: const Text('Ajukan Klaim Garansi'),
                onPressed: _isLoading ? null : _submitKlaim,
              ),
            ),

            const Divider(height: 32, thickness: 1),
            Text('Daftar Pengajuan Klaim Saya', style: AppTextStyles.heading3),
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
                            child: Text(s[0].toUpperCase() + s.substring(1)),
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

            // Daftar klaim (tidak pakai Expanded, cukup ListView shrinkWrap!)
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _userKlaimsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Belum ada klaim garansi diajukan.', style: AppTextStyles.body2),
                  );
                }

                final klaims = snapshot.data!.docs;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: klaims.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final klaim = klaims[index];
                    final status = klaim['status'] ?? 'pending';
                    final plat = klaim['plat'] ?? '';
                    final noRangka = klaim['noRangka'] ?? '';
                    final deskripsi = klaim['deskripsi'] ?? '';
                    DateTime? created;
                    if (klaim['createdAt'] != null && klaim['createdAt'] is Timestamp) {
                      created = (klaim['createdAt'] as Timestamp).toDate();
                    }

                    Color statusColor;
                    IconData statusIcon;
                    String statusText;
                    switch (status) {
                      case 'approved':
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                        statusText = 'Disetujui';
                        break;
                      case 'rejected':
                        statusColor = Colors.red;
                        statusIcon = Icons.cancel;
                        statusText = 'Ditolak';
                        break;
                      default:
                        statusColor = Colors.orange;
                        statusIcon = Icons.hourglass_top;
                        statusText = 'Pending';
                    }

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(.07),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(statusIcon, color: statusColor),
                                const SizedBox(width: 9),
                                Text('Status: $statusText',
                                    style: AppTextStyles.heading3.copyWith(color: statusColor)),
                                const Spacer(),
                                if (created != null)
                                  Text(
                                    '${created.day}-${created.month}-${created.year}',
                                    style: AppTextStyles.body2.copyWith(color: Colors.grey),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            Text('Plat: $plat', style: AppTextStyles.body2),
                            Text('No. Rangka: $noRangka', style: AppTextStyles.body2),
                            const SizedBox(height: 6),
                            Text('Deskripsi: $deskripsi', style: AppTextStyles.body2),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 40), // Biar tidak mentok di bawah
          ],
        ),
      ),
    );
  }
}
