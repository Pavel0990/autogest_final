import 'package:flutter/material.dart';
import '../data/combustible_service.dart';

class CrearCombustiblePage extends StatefulWidget {
  final int vehiculoId;

  const CrearCombustiblePage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<CrearCombustiblePage> createState() => _CrearCombustiblePageState();
}

class _CrearCombustiblePageState extends State<CrearCombustiblePage> {
  final CombustibleService service = CombustibleService();

  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  String unidad = 'litros';
  bool isLoading = false;

  Future<void> guardar() async {
    final cantidad = num.tryParse(cantidadController.text.trim());
    final monto = num.tryParse(montoController.text.trim());
    final fecha = fechaController.text.trim();

    if (cantidad == null || monto == null || fecha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa cantidad, monto y fecha'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.crearRegistro(
        vehiculoId: widget.vehiculoId,
        tipo: 'combustible',
        cantidad: cantidad,
        unidad: unidad,
        monto: monto,
        fecha: fecha,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Combustible registrado satisfactoriamente'),
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
    cantidadController.dispose();
    montoController.dispose();
    fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar combustible'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                hintText: 'Ej. 20',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: unidad,
              items: const [
                DropdownMenuItem(
                  value: 'litros',
                  child: Text('Litros'),
                ),
                DropdownMenuItem(
                  value: 'galones',
                  child: Text('Galones'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  unidad = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Unidad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                hintText: 'Ej. 2500',
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
                    : const Text('Guardar combustible'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}