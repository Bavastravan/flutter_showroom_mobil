import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set warna menu styling secara adaptif (misal pakai colorScheme.secondary dsb.)
    final menuItems = [
      {
        'icon': Icons.directions_car,
        'label': 'Katalog Mobil Bekas',
        'color': theme.colorScheme.primary, // atau theme.colorScheme.secondary
        'route': '/katalog/list-mobil'
      },
      {
        'icon': Icons.build,
        'label': 'Servis Mobil',
        'color': theme.colorScheme.secondary.withGreen(180),
        'route': '/servis/booking'
      },
      {
        'icon': Icons.extension,
        'label': 'Sparepart',
        'color': Colors.amber[700],
        'route': '/sparepart/list'
      },
      {
        'icon': Icons.verified,
        'label': 'Garansi',
        'color': Colors.teal[400],
        'route': '/garansi/klaim'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Showroom', style: theme.textTheme.titleLarge),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 1,
        centerTitle: true,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth < 600
                ? constraints.maxWidth
                : 470; // batas lebar maksimum biar grid tidak terlalu besar di desktop
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selamat datang di Dashboard!',
                          style: theme.textTheme.headlineMedium),
                      SizedBox(height: 18),
                      Text('Silakan pilih menu layanan:',
                          style: theme.textTheme.bodyMedium),
                      SizedBox(height: 28),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 22,
                          crossAxisSpacing: 22,
                          childAspectRatio: 0.93,
                        ),
                        itemCount: menuItems.length,
                        itemBuilder: (context, i) {
                          final item = menuItems[i];
                          return _DashboardMenu(
                            icon: item['icon'] as IconData,
                            label: item['label'] as String,
                            color: item['color'] as Color? ?? theme.colorScheme.primary,
                            onTap: () => Navigator.pushNamed(context, item['route'] as String),
                            textStyle: theme.textTheme.bodyLarge, // adaptif!
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const _DashboardMenu({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(isDark ? 0.19 : 0.13),
        elevation: isDark ? 2 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              SizedBox(height: 16),
              Text(
                label,
                style: (textStyle ?? theme.textTheme.bodyLarge)?.copyWith(
                  color: theme.textTheme.bodyLarge?.color, // adaptif!
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
