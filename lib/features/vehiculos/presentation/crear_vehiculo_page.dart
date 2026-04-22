import 'package:flutter/material.dart';
import '../data/vehiculos_service.dart';

class CrearVehiculoPage extends StatefulWidget {
  const CrearVehiculoPage({super.key});

  @override
  State<CrearVehiculoPage> createState() => _CrearVehiculoPageState();
}

class _CrearVehiculoPageState extends State<CrearVehiculoPage> {
  final VehiculosService service = VehiculosService();

  final TextEditingController placaController = TextEditingController();
  final TextEditingController chasisController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anioController = TextEditingController();
  final TextEditingController ruedasController = TextEditingController();

  bool isLoading = false;

  Future<void> guardarVehiculo() async {
    final placa = placaController.text.trim();
    final chasis = chasisController.text.trim();
    final marca = marcaController.text.trim();
    final modelo = modeloController.text.trim();
    final anioText = anioController.text.trim();
    final ruedasText = ruedasController.text.trim();

    if (placa.isEmpty ||
        chasis.isEmpty ||
        marca.isEmpty ||
        modelo.isEmpty ||
        anioText.isEmpty ||
        ruedasText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final anio = int.tryParse(anioText);
    final ruedas = int.tryParse(ruedasText);

    if (anio == null || ruedas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Año y ruedas deben ser numéricos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.crearVehiculo(
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        cantidadRuedas: ruedas,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehículo registrado correctamente')),
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
    ruedasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Vehículo'),
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
            const SizedBox(height: 16),
            TextField(
              controller: ruedasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad de ruedas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : guardarVehiculo,
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar vehículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}