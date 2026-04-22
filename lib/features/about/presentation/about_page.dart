import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir el enlace');
    }
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (!await launchUrl(uri)) {
      throw Exception('No se pudo abrir el teléfono');
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri)) {
      throw Exception('No se pudo abrir el correo');
    }
  }

  Widget memberCard({
    required BuildContext context,
    required String name,
    required String matricula,
    required String phone,
    required String telegram,
    required String email,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Matrícula: $matricula'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _callPhone(phone),
                  icon: const Icon(Icons.phone),
                  label: const Text('Llamar'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _openLink(telegram),
                  icon: const Icon(Icons.telegram),
                  label: const Text('Telegram'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _sendEmail(email),
                  icon: const Icon(Icons.email),
                  label: const Text('Correo'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              phone,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Equipo de desarrollo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'AutoZone ITLA - Proyecto Final Apps Móviles',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          memberCard(
            context: context,
            name: 'Pavel Abreu Torres',
            matricula: '20231066',
            phone: '809-352-7500',
            telegram: 'Falta agregar enlace de Telegram',
            email: '20231066@itla.edu.do',
            imageUrl: 'https://scontent.fsti4-2.fna.fbcdn.net/v/t39.30808-6/481992940_1908523826345395_809553625408717298_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=2a1932&_nc_eui2=AeFse1ewNSgFfCqQIq07QUjWavIB7farhuxq8gHt9quG7OZ1pJnz21XSyUgR81UW6xyZ5RdkAyPGOh7-Etk4rrBd&_nc_ohc=lSk3kWUeBjMQ7kNvwE2IdI-&_nc_oc=Adr7mQ3U7xZofZotUkKvC0ZKpYHOJhLdBvuZ_lbpla8b5IoYg0KFr97iu1G-ii_KClb_imdOSTt3xabtRf97UvGC&_nc_zt=23&_nc_ht=scontent.fsti4-2.fna&_nc_gid=6UN2xsFaZBgw40WVEeiMIg&_nc_ss=7a2a8&oh=00_Af1ODhupEKU_R3znpzyCE5jRIUAwAVlKbB_qvtTI74q9VA&oe=69EF11E4',
          ),

        ],
      ),
    );
  }
}