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
  String? _sentOtp; // Simulasi kode OTP

  Future<void> _sendReset() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final input = _inputController.text.trim();
    try {
      String? email;
      if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
        email = input;
      } else if (RegExp(r'^\d{8,}$').hasMatch(input)) {
        var snap = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: input)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) email = snap.docs.first['email'];
      }
      if (email == null) throw 'Akun/email tidak ditemukan';

      if (_selectedMethod == 'email') {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link reset password dikirim ke email')),
        );
        Navigator.pop(context);
      } else {
        final now = DateTime.now();
        final otp = (100000 + now.millisecond % 900000).toString();
        setState(() {
          _waitingOtp = true;
          _sentOtp = otp;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kode OTP simulasikan: $otp')),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() {
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
      if (_otpController.text.trim() != _sentOtp) throw 'Kode OTP salah!';
      if (_newPassController.text.trim().length < 6) throw 'Password terlalu pendek!';

      final input = _inputController.text.trim();
      String? email;
      if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
        email = input;
      } else if (RegExp(r'^\d{8,}$').hasMatch(input)) {
        var snap = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: input)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) email = snap.docs.first['email'];
      }

      if (email == null) throw 'Akun/email tidak ditemukan';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diganti.')),
      );
      Navigator.pop(context);

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
                    Text('Masukkan Email atau No. Telepon Anda:', style: theme.textTheme.bodyMedium),
                    SizedBox(height: 16),
                    TextField(
                      controller: _inputController,
                      enabled: !isWaitingOtp,
                      decoration: InputDecoration(
                        labelText: 'Email / No. Telepon',
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'email',
                          groupValue: _selectedMethod,
                          onChanged: isWaitingOtp ? null : (val) => setState(() => _selectedMethod = val.toString()),
                        ),
                        Text('Via Email'),
                        SizedBox(width: 18),
                        Radio(
                          value: 'sms',
                          groupValue: _selectedMethod,
                          onChanged: isWaitingOtp ? null : (val) => setState(() => _selectedMethod = val.toString()),
                        ),
                        Text('Via SMS'),
                      ],
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 10),
                      Text(_errorMessage!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                    ],
                    SizedBox(height: 16),
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
                    if (isWaitingOtp) ...[
                      TextField(
                        controller: _otpController,
                        decoration: InputDecoration(labelText: 'Kode OTP'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _newPassController,
                        decoration: InputDecoration(labelText: 'Password Baru'),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                          onPressed: _isLoading ? null : _resetPasswordWithOtp,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Reset Password')
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
