import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_page.dart';
import '../../noticias/presentation/noticias_page.dart';
import '../../vehiculos/presentation/vehiculos_page.dart';
import '../../videos/presentation/videos_page.dart';
import '../../perfil/presentation/perfil_page.dart';
import '../../foro/presentation/foro_page.dart';
import '../../catalogo/presentation/catalogo_page.dart';
import '../../about/presentation/about_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    final List<String> images = [
      'https://w.wallhaven.cc/full/4y/wallhaven-4yjlkd.jpg',
      'https://w.wallhaven.cc/full/nm/wallhaven-nmmogk.jpg',
      'https://w.wallhaven.cc/full/ne/wallhaven-ne76ll.jpg',
      'https://w.wallhaven.cc/full/e7/wallhaven-e7xm5w.jpg'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoZone ITLA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Iniciar sesión',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await authService.logout();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: images.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cuida tu vehículo hoy para evitar problemas mañana.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Gestiona tus mantenimientos, combustible, gastos, ingresos y participa en la comunidad desde una sola app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _DashboardCard(
                    icon: Icons.newspaper,
                    title: 'Noticias',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NoticiasPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.video_library,
                    title: 'Videos',
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VideosPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.directions_car,
                    title: 'Mis Vehículos',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VehiculosPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.person,
                    title: 'Mi Perfil',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerfilPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.forum,
                    title: 'Foro',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForoPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.storefront,
                    title: 'Catálogo',
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatalogoPage(),
                        ),
                      );
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.info,
                    title: 'Acerca de',
                    color: Colors.brown,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}