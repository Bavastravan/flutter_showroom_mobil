import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _inputController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPassController = TextEditingController();
  
  String _selectedMethod = 'email'; // email or sms
  String? _errorMessage;
  bool _waitingOtp = false;
  bool _isLoading = false;
  
  // Variabel baru untuk menyimpan ID verifikasi dari Firebase (Pengganti _sentOtp)
  String? _verificationId; 

  @override
  void dispose() {
    _inputController.dispose();
    _otpController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

 // Helper: Pastikan nomor HP selalu format +62
  String _formatPhoneNumber(String phone) {
    String cleanPhone = phone.trim();
    if (cleanPhone.startsWith('0')) {
      return '+62${cleanPhone.substring(1)}';
    } else if (cleanPhone.startsWith('62')) {
      return '+$cleanPhone';
    }
    // Jika user sudah mengetik +62, biarkan saja
    return cleanPhone;
  }

  Future<void> _sendReset() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    
    final input = _inputController.text.trim();
    
    try {
      String? email;
      String? phoneNumber;

      // --- LOGIKA 1: CEK APAKAH INPUT ADALAH EMAIL ---
      if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
        email = input;
        _selectedMethod = 'email';
        
        // Opsional: Cek apakah email ada di Firestore
        // (Bisa dilewati karena sendPasswordResetEmail tidak akan error fatal jika email tidak ada)
      } 
      
      // --- LOGIKA 2: CEK APAKAH INPUT ADALAH NO HP ---
      else if (RegExp(r'^\d{8,}$').hasMatch(input)) {
        _selectedMethod = 'sms';
        
        // 1. Format input user menjadi +62
        String formattedPhone = _formatPhoneNumber(input);
        print("Mencari nomor di database: $formattedPhone"); // Debugging

        // 2. Cek ke Firestore: Apakah nomor ini ada?
        var snap = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: formattedPhone) // Cari yang format +62
            .limit(1)
            .get();
        
        // Jika tidak ketemu dengan +62, coba cari dengan input asli (jaga-jaga data lama)
        if (snap.docs.isEmpty) {
           snap = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: input)
            .limit(1)
            .get();
        }

        if (snap.docs.isNotEmpty) {
          // USER DITEMUKAN!
          // Pastikan kita mengirim SMS ke nomor yang formatnya +62 (E.164)
          phoneNumber = formattedPhone; 
        } else {
          throw 'Nomor telepon tidak terdaftar di sistem.';
        }
      } else {
        throw 'Format Email atau Nomor Telepon tidak valid.';
      }

      // --- LOGIKA 3: EKSEKUSI PENGIRIMAN ---
      if (_selectedMethod == 'email') {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link reset password telah dikirim ke email.')),
        );
        Navigator.pop(context);
        setState(() => _isLoading = false);

      } else {
        // --- KIRIM SMS (FIREBASE AUTH) ---
        // PENTING: phoneNumber di sini sudah pasti format +62
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber!, 
          timeout: const Duration(seconds: 60),
          
          // Android: Verifikasi Otomatis (Tanpa input kode)
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Opsional: Langsung login jika otomatis
            // Tapi untuk reset password, lebih aman biarkan user isi password baru dulu
            print("Verifikasi Otomatis Berhasil");
          },

          // Gagal Kirim
          verificationFailed: (FirebaseAuthException e) {
            print("Gagal Kirim SMS: ${e.code} - ${e.message}");
            setState(() {
              _isLoading = false;
              if (e.code == 'invalid-phone-number') {
                _errorMessage = 'Format nomor telepon salah.';
              } else if (e.code == 'too-many-requests') {
                _errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti.';
              } else {
                _errorMessage = e.message; // Tampilkan pesan asli untuk debugging
              }
            });
          },

          // Berhasil Kirim SMS
          codeSent: (String verificationId, int? resendToken) {
            print("SMS Terkirim! ID: $verificationId");
            setState(() {
              _verificationId = verificationId; // Simpan kunci rahasia
              _waitingOtp = true; // Pindah tampilan ke input OTP
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kode OTP dikirim ke $phoneNumber')),
            );
          },

          // Waktu Habis
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPasswordWithOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final smsCode = _otpController.text.trim();
      final newPass = _newPassController.text.trim();

      if (smsCode.isEmpty) throw 'Masukkan Kode OTP!';
      if (newPass.length < 6) throw 'Password minimal 6 karakter!';
      if (_verificationId == null) throw 'Gagal verifikasi. Kirim ulang kode.';

      // 1. Buat Credential dari kode yang diinput user
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // 2. Login Sementara menggunakan No HP tersebut
      // (Kita harus login untuk dapat hak akses ganti password)
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      User? user = userCredential.user;

      if (user != null) {
        // 3. Update Password User
        await user.updatePassword(newPass);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password berhasil diganti! Silakan login.')),
        );
        
        // 4. Logout (Agar aman)
        await FirebaseAuth.instance.signOut();
        
        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? 'Terjadi kesalahan';
      if (e.code == 'invalid-verification-code') msg = 'Kode OTP salah!';
      setState(() => _errorMessage = msg);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWaitingOtp = _waitingOtp && _selectedMethod == 'sms';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password', style: theme.textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      isWaitingOtp ? 'Verifikasi OTP SMS' : 'Lupa Password?', 
                      style: theme.textTheme.headlineSmall
                    ),
                    if (!isWaitingOtp)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Masukkan Email atau No. Telepon Anda:', style: theme.textTheme.bodyMedium),
                      ),
                    SizedBox(height: 16),
                    
                    // --- STEP 1: Input Email/HP ---
                    if (!isWaitingOtp) ...[
                      TextField(
                        controller: _inputController,
                        decoration: InputDecoration(
                          labelText: 'Email / No. Telepon',
                          hintText: 'Contoh: 08123456789',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Pilihan Radio Button (Otomatis terpilih berdasarkan input)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 'email',
                            groupValue: _selectedMethod,
                            onChanged: (val) => setState(() => _selectedMethod = val.toString()),
                          ),
                          Text('Via Email'),
                          SizedBox(width: 18),
                          Radio(
                            value: 'sms',
                            groupValue: _selectedMethod,
                            onChanged: (val) => setState(() => _selectedMethod = val.toString()),
                          ),
                          Text('Via SMS'),
                        ],
                      ),
                    ],

                    if (_errorMessage != null) ...[
                      SizedBox(height: 10),
                      Text(_errorMessage!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center),
                    ],
                    
                    SizedBox(height: 16),
                    
                    // Tombol Kirim Kode/Link
                    if (!isWaitingOtp)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendReset,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(_selectedMethod == 'email'
                                  ? 'Kirim Link ke Email'
                                  : 'Kirim Kode ke SMS'),
                        ),
                      ),
                    
                    // --- STEP 2: Input OTP & Password Baru ---
                    if (isWaitingOtp) ...[
                      TextField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          labelText: 'Kode OTP (6 Digit)',
                          prefixIcon: Icon(Icons.sms),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _newPassController,
                        decoration: InputDecoration(
                          labelText: 'Password Baru',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPasswordWithOtp,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Ubah Password'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _waitingOtp = false;
                            _errorMessage = null;
                            _otpController.clear();
                            _newPassController.clear();
                          });
                        },
                        child: Text("Ganti Nomor / Metode"),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}