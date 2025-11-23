import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../themes/text_styles.dart';

class BookingScreen extends StatefulWidget {
  final String? mobilId; // opsional, bisa diterima dari argument
  const BookingScreen({Key? key, this.mobilId}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage, _successMessage;

  Future<void> _submitBooking(String? mobilId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = 'Anda belum login.';
        _isLoading = false;
      });
      return;
    }
    if (_selectedDate == null) {
      setState(() {
        _errorMessage = 'Pilih tanggal booking terlebih dahulu.';
        _isLoading = false;
      });
      return;
    }
    if (mobilId == null || mobilId.isEmpty) {
      setState(() {
        _errorMessage = 'Mobil belum dipilih (ID tidak ditemukan).';
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'mobilId': mobilId, // Pakai variabel lokal!
        'tanggal': _selectedDate,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      setState(() {
        _successMessage = 'Booking berhasil! Tim showroom akan menghubungi Anda.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal booking, coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil id mobil dari argument Navigator
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String? mobilId = widget.mobilId ?? (args is String ? args : null);

    return Scaffold(
      appBar: AppBar(title: Text('Booking Mobil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Pilih tanggal booking mobil',
              style: AppTextStyles.heading3,
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Belum ada tanggal dipilih'
                        : 'Tanggal: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                    style: AppTextStyles.body2,
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_successMessage != null)
              Text(_successMessage!, style: TextStyle(color: Colors.green)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.book_online),
                label: Text('Booking Sekarang'),
                onPressed: _isLoading ? null : () => _submitBooking(mobilId), // Panggil dengan argumen lokal!
              ),
            ),
          ],
        ),
      ),
    );
  }
}
