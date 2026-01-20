import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:showroom_mobil/screens/profile_screen.dart';

// Import theme
import 'themes/colors.dart';
import 'themes/text_styles.dart';
import 'themes/dark.dart';
import 'utils/theme_mode_notifier.dart';

// Import screens
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/katalog/list_mobil_screen.dart';
import 'screens/katalog/detail_mobil_screen.dart';
import 'screens/servis/booking_screen.dart'; // Ini booking servis (bawaan lama)
import 'screens/servis/jadwal_screen.dart';
import 'screens/sparepart/list_sparepart_screen.dart';
import 'screens/sparepart/detail_sparepart_screen.dart';
import 'screens/garansi/klaim_screen.dart';
import 'screens/reset_password_screen.dart';

// --- IMPORT FILE TRANSAKSI ---
import 'screens/transaksi/pesan_mobil_screen.dart';
import 'screens/transaksi/pesan_sparepart_screen.dart'; // Import pesan sparepart

final themeModeNotifier = ThemeModeNotifier();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBUbD5ju-_mZrGNvPMv_E5wzJs99rkjF1g",
      authDomain: "showroom-mobil-b887f.firebaseapp.com",
      projectId: "showroom-mobil-b887f",
      storageBucket: "showroom-mobil-b887f.appspot.com",
      messagingSenderId: "617307420486",
      appId: "1:617307420486:web:0414862e8365c482de5747",
      measurementId: "G-3H4MTDYC87",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Showroom Mobil Bekas',
          debugShowCheckedModeBanner: false,
          
          // Konfigurasi Tema Light
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              secondary: AppColors.accentColor,
              background: AppColors.background,
              surface: AppColors.card,
              error: AppColors.danger,
            ),
            scaffoldBackgroundColor: AppColors.background,
            cardColor: AppColors.card,
            textTheme: TextTheme(
              displayLarge: AppTextStyles.heading1.copyWith(color: Colors.black),
              displayMedium: AppTextStyles.heading2.copyWith(color: Colors.black87),
              displaySmall: AppTextStyles.heading3.copyWith(color: Colors.black87),
              headlineMedium: AppTextStyles.heading2.copyWith(color: Colors.black87),
              titleLarge: AppTextStyles.cardTitle.copyWith(color: Colors.black87),
              bodyLarge: AppTextStyles.body1.copyWith(color: Colors.black87),
              bodyMedium: AppTextStyles.body2.copyWith(color: Colors.black54),
              labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
          
          // Konfigurasi Tema Dark
          darkTheme: AppDarkTheme.themeData,
          themeMode: mode,
          
          initialRoute: '/',
          
          // DAFTAR RUTE NAVIGASI
          routes: {
            '/': (context) => LandingScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/dashboard': (context) => DashboardScreen(),
            
            // Katalog Mobil
            '/katalog/list-mobil': (context) => ListMobilScreen(),
            '/katalog/detail-mobil': (context) => DetailMobilScreen(),
            
            // Transaksi Mobil (Checkout)
            '/katalog/detail-mobil/booking': (context) => const PesanMobilScreen(),

            // Servis
            '/servis/booking': (context) => BookingScreen(), // Booking Servis
            '/servis/jadwal': (context) => JadwalScreen(),

            // Sparepart
            '/sparepart/list': (context) => ListSparepartScreen(),
            '/sparepart/detail': (context) => DetailSparepartScreen(),
            
            // Transaksi Sparepart (Checkout) - BARU DITAMBAHKAN
            '/sparepart/pesan': (context) => const PesanSparepartScreen(),

            // Lainnya
            '/garansi/klaim': (context) => KlaimScreen(),
            '/reset-password': (context) => ResetPasswordScreen(),
            '/profil': (context) => ProfileScreen(),
          },
        );
      },
    );
  }
}