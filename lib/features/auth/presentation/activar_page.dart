import 'package:flutter/material.dart';
import '../../dashboard/presentation/dashboard_page.dart';
import '../data/auth_service.dart';

class ActivarPage extends StatefulWidget {
  final String tokenTemporal;

  const ActivarPage({
    super.key,
    required this.tokenTemporal,
  });

  @override
  State<ActivarPage> createState() => _ActivarPageState();
}

class _ActivarPageState extends State<ActivarPage> {
  final AuthService service = AuthService();
  final TextEditingController contrasenaController = TextEditingController();

  bool isLoading = false;

  Future<void> activar() async {
    final contrasena = contrasenaController.text.trim();

    if (contrasena.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.activarCuenta(
        tokenTemporal: widget.tokenTemporal,
        contrasena: contrasena,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activar Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Token recibido: ${widget.tokenTemporal}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                hintText: 'Mínimo 6 caracteres',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : activar,
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Activar cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}