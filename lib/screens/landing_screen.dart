import 'package:flutter/material.dart';
import '../../main.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 600
                    ? constraints.maxWidth * 0.9
                    : 420;
                return Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/images/showroom_logo.png'),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Selamat Datang di Showroom Mobil Bekas!',
                            style: theme.textTheme.displayLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Temukan mobil impianmu, servis, sparepart, dan garansi terbaik dari showroom kami.',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.login, color: Colors.white),
                              label: Text('Masuk'), // tanpa style langsung!
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              style: ElevatedButton.styleFrom(
                                textStyle: theme.textTheme.labelLarge, // jika perlu style
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.person_add, color: theme.colorScheme.secondary),
                              label: Text('Daftar'), // tanpa style langsung!
                              onPressed: () => Navigator.pushNamed(context, '/register'),
                              style: OutlinedButton.styleFrom(
                                textStyle: theme.textTheme.labelLarge, // jika perlu
                                side: BorderSide(color: theme.colorScheme.secondary),
                                foregroundColor: theme.colorScheme.secondary,
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.secondary,
                              textStyle: theme.textTheme.labelLarge,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/katalog/list-mobil'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search, size: 20, color: theme.colorScheme.secondary),
                                const SizedBox(width: 6),
                                Text('Lihat Katalog Mobil Bekas'), // tanpa style langsung!
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Switch(
                    value: isDark,
                    onChanged: (val) => themeModeNotifier.toggleMode(),
                    activeColor: theme.colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
