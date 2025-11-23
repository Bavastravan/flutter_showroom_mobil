import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _inputController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscure = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String input = _inputController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await AuthService().loginWithUsernameOrPhone(
        input: input,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on Exception catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginGoogle() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      var user = await AuthService().loginWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginApple() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      var user = await AuthService().loginWithApple();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Masuk ke Showroom", style: theme.textTheme.headlineMedium),
        centerTitle: true,
        elevation: 1,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 500 ? constraints.maxWidth : 400;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Card(
                      color: theme.cardColor,
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Icon(Icons.login, size: 54, color: theme.colorScheme.secondary),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Selamat Datang!",
                              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Masukkan akunmu untuk melanjutkan",
                              style: theme.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 32),
                            TextField(
                              controller: _inputController,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Email / Username / No. Telepon',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.person, color: theme.iconTheme.color),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: theme.textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: theme.iconTheme.color),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                              ),
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/reset-password');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.secondary,
                                ),
                                child: Text('Lupa password?', style: theme.textTheme.bodyMedium),
                              ),
                            ),
                            if (_errorMessage != null) ...[
                              SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                              ),
                            ],
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.secondary,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text('Masuk', style: theme.textTheme.labelLarge),
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.secondary,
                                ),
                                child: Text("Belum punya akun? Daftar", style: theme.textTheme.bodyMedium),
                              ),
                            ),
                            Divider(height: 32),
                            // Google login button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                                label: Text("Masuk dengan Google", style: theme.textTheme.labelLarge),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _isLoading ? null : _loginGoogle,
                              ),
                            ),
                            SizedBox(height: 12),
                            // tombol login Apple (hanya muncul di iOS/macOS)
                            if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.apple, color: Colors.white),
                                  label: Text("Masuk dengan Apple", style: theme.textTheme.labelLarge),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: _isLoading ? null : _loginApple,
                                ),
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
