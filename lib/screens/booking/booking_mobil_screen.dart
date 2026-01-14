import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Pastikan sudah add intl di pubspec.yaml

class BookingMobilScreen extends StatefulWidget {
  const BookingMobilScreen({Key? key}) : super(key: key);

  @override
  State<BookingMobilScreen> createState() => _BookingMobilScreenState();
}

class _BookingMobilScreenState extends State<BookingMobilScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk input text
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  
  DateTime? _selectedDate;
  bool _isLoading = false;

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi Submit ke Firebase
  Future<void> _submitBooking(String mobilId) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal kunjungan/booking')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Siapkan data booking
      final bookingData = {
        'mobilId': mobilId,
        'namaPemesan': _namaController.text,
        'noHp': _noHpController.text,
        'alamat': _alamatController.text,
        'catatan': _catatanController.text,
        'tanggalBooking': Timestamp.fromDate(_selectedDate!),
        'tanggalDibuat': FieldValue.serverTimestamp(),
        'status': 'Menunggu Konfirmasi', // Status awal
      };

      // 2. Simpan ke collection 'bookings'
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);

      // 3. Tampilkan sukses & kembali
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Berhasil! Showroom akan menghubungi Anda.')),
      );
      
      // Kembali ke dashboard (hapus history agar tidak bisa back ke form)
      Navigator.popUntil(context, (route) => route.isFirst);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal booking: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ID Mobil dari halaman sebelumnya
    final mobilId = ModalRoute.of(context)?.settings.arguments as String?;

    if (mobilId == null) {
      return const Scaffold(body: Center(child: Text("Error: ID Mobil tidak ditemukan")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Pemesanan"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Isi data diri untuk booking unit",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // INPUT NAMA
                _buildLabel("Nama Lengkap"),
                TextFormField(
                  controller: _namaController,
                  decoration: _inputDecoration("Contoh: Budi Santoso"),
                  validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // INPUT NO HP
                _buildLabel("Nomor WhatsApp / HP"),
                TextFormField(
                  controller: _noHpController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration("Contoh: 08123456789"),
                  validator: (val) => val!.isEmpty ? "Nomor HP wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // INPUT TANGGAL (Custom Widget)
                _buildLabel("Rencana Lihat Unit / Kunjungan"),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? "Pilih Tanggal"
                              : DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null ? Colors.grey : Colors.black,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blueGrey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // INPUT ALAMAT
                _buildLabel("Alamat Domisili"),
                TextFormField(
                  controller: _alamatController,
                  maxLines: 2,
                  decoration: _inputDecoration("Alamat lengkap Anda"),
                  validator: (val) => val!.isEmpty ? "Alamat wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // INPUT CATATAN
                _buildLabel("Catatan Tambahan (Opsional)"),
                TextFormField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: _inputDecoration("Misal: Ingin test drive jam 10 pagi"),
                ),
                const SizedBox(height: 32),

                // TOMBOL SUBMIT
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isLoading ? null : () => _submitBooking(mobilId),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Kirim Pemesanan",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  // Helper Decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}