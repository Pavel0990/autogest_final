import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'activar_page.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final AuthService service = AuthService();
  final TextEditingController matriculaController = TextEditingController();

  bool isLoading = false;

  Future<void> registrar() async {
    final matricula = matriculaController.text.trim();

    if (matricula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe tu matrícula')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final tokenTemporal = await service.registrarUsuario(matricula);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token recibido: $tokenTemporal')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ActivarPage(tokenTemporal: tokenTemporal),
        ),
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
    matriculaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: matriculaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Matrícula ITLA',
                hintText: '20231066',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : registrar,
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Registrarme'),
            ),
          ],
        ),
      ),
    );
  }
}