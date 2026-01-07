import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart'; // Untuk mock Image.network
import 'package:katalog_app/main.dart'; // Sesuaikan dengan nama package Anda

void main() {
  // Grup pengujian untuk MainPage
  group('MainPage Widget Tests', () {
    testWidgets('MainPage renders with BottomNavigationBar and ProdukPage',
        (WidgetTester tester) async {
      // Mock pemuatan gambar jaringan
      await mockNetworkImagesFor(() async {
        // Build aplikasi dan trigger frame
        await tester.pumpWidget(const MyApp());

        // Verifikasi bahwa AppBar dengan judul '🛍 Katalog Produk' ada di ProdukPage
        expect(find.text('🛍 Katalog Produk'), findsOneWidget);

        // Verifikasi bahwa BottomNavigationBar memiliki 4 item
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        expect(find.text('Beranda'), findsOneWidget);
        expect(find.text('Favorit'), findsOneWidget);
        expect(find.text('Keranjang'), findsOneWidget);
        expect(find.text('Profil'), findsOneWidget);

        // Verifikasi bahwa beberapa produk ditampilkan di grid
        expect(find.text('Laptop Gaming'), findsOneWidget);
        expect(find.text('Headphone Premium'), findsOneWidget);
        expect(find.text('Rp 15.999.000'), findsOneWidget); // Harga Laptop Gaming
      });
    });

    testWidgets('BottomNavigationBar navigates to FavoritePage',
        (WidgetTester tester) async {
      // Mock pemuatan gambar jaringan
      await mockNetworkImagesFor(() async {
        // Build aplikasi dan trigger frame
        await tester.pumpWidget(const MyApp());

        // Verifikasi bahwa kita mulai di ProdukPage
        expect(find.text('🛍 Katalog Produk'), findsOneWidget);

        // Ketuk item 'Favorit' di BottomNavigationBar
        await tester.tap(find.text('Favorit'));
        await tester.pumpAndSettle(); // Tunggu hingga animasi selesai

        // Verifikasi bahwa kita berada di FavoritePage
        expect(find.text('❤ Halaman Favorit'), findsOneWidget);
      });
    });

    testWidgets('BottomNavigationBar navigates to CartPage',
        (WidgetTester tester) async {
      // Mock pemuatan gambar jaringan
      await mockNetworkImagesFor(() async {
        // Build aplikasi dan trigger frame
        await tester.pumpWidget(const MyApp());

        // Verifikasi bahwa kita mulai di ProdukPage
        expect(find.text('🛍 Katalog Produk'), findsOneWidget);

        // Ketuk item 'Keranjang' di BottomNavigationBar
        await tester.tap(find.text('Keranjang'));
        await tester.pumpAndSettle();

        // Verifikasi bahwa kita berada di CartPage
        expect(find.text('🛒 Halaman Keranjang'), findsOneWidget);
      });
    });

    testWidgets('BottomNavigationBar navigates to ProfilePage',
        (WidgetTester tester) async {
      // Mock pemuatan gambar jaringan
      await mockNetworkImagesFor(() async {
        // Build aplikasi dan trigger frame
        await tester.pumpWidget(const MyApp());

        // Verifikasi bahwa kita mulai di ProdukPage
        expect(find.text('🛍 Katalog Produk'), findsOneWidget);

        // Ketuk item 'Profil' di BottomNavigationBar
        await tester.tap(find.text('Profil'));
        await tester.pumpAndSettle();

        // Verifikasi bahwa kita berada di ProfilePage
        expect(find.text('👤 Halaman Profil'), findsOneWidget);
      });
    });

    testWidgets('Buy button shows SnackBar', (WidgetTester tester) async {
      // Mock pemuatan gambar jaringan
      await mockNetworkImagesFor(() async {
        // Build aplikasi dan trigger frame
        await tester.pumpWidget(const MyApp());

        // Verifikasi bahwa tombol "Beli Sekarang" ada
        expect(find.text('Beli Sekarang'), findsWidgets);

        // Ketuk tombol "Beli Sekarang" untuk produk pertama
        await tester.tap(find.text('Beli Sekarang').first);
        await tester.pumpAndSettle();

        // Verifikasi bahwa SnackBar muncul dengan pesan yang benar
        expect(find.text('Kamu membeli Laptop Gaming!'), findsOneWidget);
      });
    });
  });
}