import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;
  String? _errorMessage;

  // Helper untuk format nomor HP ke +62
  String _formatPhoneToE164(String phone) {
    if (phone.startsWith('0')) {
      return '+62${phone.substring(1)}';
    } else if (phone.startsWith('62')) {
      return '+$phone';
    }
    return phone;
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String rawPhone = _phoneController.text.trim(); // Ambil input asli
    String password = _passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || rawPhone.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi!';
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. Format nomor HP agar standar (PENTING untuk Reset Password)
      String formattedPhone = _formatPhoneToE164(rawPhone);

      // 2. Cek Username (duplikasi)
      var usernameSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameSnap.docs.isNotEmpty) {
        throw 'Username sudah dipakai!';
      }

      // 3. Cek Nomor HP (duplikasi) - Gunakan nomor yang sudah diformat
      var phoneSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .get();
      if (phoneSnap.docs.isNotEmpty) {
        throw 'No. telepon sudah terdaftar!';
      }

      // 4. Buat Akun di Firebase Auth
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 5. Simpan Data ke Firestore
      // PENTING: Simpan 'phone' dengan format +62 agar Reset Password bisa menemukannya
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'username': username,
        'phone': formattedPhone, // <--- Disimpan sebagai +62
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user', // Opsional: Tambahkan role default
      });

      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = 'Email sudah terdaftar!';
        } else if (e.code == 'weak-password') {
          _errorMessage = 'Password terlalu lemah (min. 6 karakter)';
        } else {
          _errorMessage = e.message;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Daftar Akun Showroom', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 500
                    ? constraints.maxWidth
                    : 400;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Card(
                      elevation: 7,
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.account_circle, size: 56, color: theme.colorScheme.secondary),
                            SizedBox(height: 20),
                            // Email
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.email_outlined, color: theme.iconTheme.color),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 14),
                            // Username
                            TextField(
                              controller: _usernameController,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 14),
                            // No Telp
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'No. Telepon (Contoh: 0812345...)',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.phone_outlined, color: theme.iconTheme.color),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 14),
                            // Password
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.lock_outline, color: theme.iconTheme.color),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: theme.iconTheme.color),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 18),
                            if (_errorMessage != null)
                              Text(_errorMessage!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  )),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: theme.colorScheme.secondary,
                                ),
                                onPressed: _isLoading ? null : _register,
                                child: _isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text('Daftar', style: theme.textTheme.labelLarge),
                              ),
                            ),
                            SizedBox(height: 14),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.secondary,
                              ),
                              child: Text('Sudah punya akun? Masuk',
                                  style: theme.textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}