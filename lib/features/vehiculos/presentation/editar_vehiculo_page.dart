import 'package:flutter/material.dart';
import '../data/vehiculos_service.dart';
import '../models/vehiculo_detalle_model.dart';

class EditarVehiculoPage extends StatefulWidget {
  final VehiculoDetalleModel vehiculo;

  const EditarVehiculoPage({
    super.key,
    required this.vehiculo,
  });

  @override
  State<EditarVehiculoPage> createState() => _EditarVehiculoPageState();
}

class _EditarVehiculoPageState extends State<EditarVehiculoPage> {
  final VehiculosService service = VehiculosService();

  late final TextEditingController placaController;
  late final TextEditingController chasisController;
  late final TextEditingController marcaController;
  late final TextEditingController modeloController;
  late final TextEditingController anioController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    placaController = TextEditingController(text: widget.vehiculo.placa);
    chasisController = TextEditingController(text: widget.vehiculo.chasis);
    marcaController = TextEditingController(text: widget.vehiculo.marca);
    modeloController = TextEditingController(text: widget.vehiculo.modelo);
    anioController =
        TextEditingController(text: widget.vehiculo.anio.toString());
  }

  Future<void> guardarCambios() async {
    final placa = placaController.text.trim();
    final chasis = chasisController.text.trim();
    final marca = marcaController.text.trim();
    final modelo = modeloController.text.trim();
    final anio = int.tryParse(anioController.text.trim());

    if (placa.isEmpty ||
        chasis.isEmpty ||
        marca.isEmpty ||
        modelo.isEmpty ||
        anio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos correctamente')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.editarVehiculo(
        id: widget.vehiculo.id,
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehículo actualizado correctamente')),
      );

      Navigator.pop(context, true);
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
    placaController.dispose();
    chasisController.dispose();
    marcaController.dispose();
    modeloController.dispose();
    anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Vehículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: placaController,
              decoration: const InputDecoration(
                labelText: 'Placa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: chasisController,
              decoration: const InputDecoration(
                labelText: 'Chasis',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: anioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Año',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : guardarCambios,
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}