import 'package:flutter/material.dart';
import '../data/ingresos_service.dart';

class CrearIngresoPage extends StatefulWidget {
  final int vehiculoId;

  const CrearIngresoPage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<CrearIngresoPage> createState() => _CrearIngresoPageState();
}

class _CrearIngresoPageState extends State<CrearIngresoPage> {
  final IngresosService service = IngresosService();

  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  bool isLoading = false;

  Future<void> guardar() async {
    final monto = num.tryParse(montoController.text.trim());
    final fecha = fechaController.text.trim();
    final descripcion = descripcionController.text.trim();

    if (monto == null || fecha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa monto y fecha'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.crearIngreso(
        vehiculoId: widget.vehiculoId,
        monto: monto,
        fecha: fecha,
        descripcion: descripcion,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingreso registrado satisfactoriamente'),
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
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
    montoController.dispose();
    fechaController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar ingreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                hintText: 'Ej. 5000',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                hintText: '2026-04-22',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej. Ganancia por viaje, alquiler...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : guardar,
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar ingreso'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}