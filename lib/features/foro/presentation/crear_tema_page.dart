import 'package:flutter/material.dart';
import '../../vehiculos/data/vehiculos_service.dart';
import '../../vehiculos/models/vehiculo_model.dart';
import '../data/foro_service.dart';

class CrearTemaPage extends StatefulWidget {
  const CrearTemaPage({super.key});

  @override
  State<CrearTemaPage> createState() => _CrearTemaPageState();
}

class _CrearTemaPageState extends State<CrearTemaPage> {
  final ForoService foroService = ForoService();
  final VehiculosService vehiculosService = VehiculosService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  List<VehiculoModel> vehiculos = [];
  int? vehiculoSeleccionado;
  bool isLoadingVehiculos = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarVehiculos();
  }

  Future<void> cargarVehiculos() async {
    final data = await vehiculosService.getVehiculos();

    if (!mounted) return;

    setState(() {
      vehiculos = data.where((v) => v.fotoUrl.isNotEmpty).toList();
      if (vehiculos.isNotEmpty) {
        vehiculoSeleccionado = vehiculos.first.id;
      }
      isLoadingVehiculos = false;
    });
  }

  Future<void> guardar() async {
    final titulo = tituloController.text.trim();
    final descripcion = descripcionController.text.trim();

    if (vehiculoSeleccionado == null ||
        titulo.isEmpty ||
        descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await foroService.crearTema(
        vehiculoId: vehiculoSeleccionado!,
        titulo: titulo,
        descripcion: descripcion,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tema creado correctamente'),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
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
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear tema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoadingVehiculos
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: vehiculoSeleccionado,
                    items: vehiculos.map((vehiculo) {
                      return DropdownMenuItem<int>(
                        value: vehiculo.id,
                        child: Text('${vehiculo.marca} ${vehiculo.modelo}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        vehiculoSeleccionado = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Vehículo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descripcionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
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
                          : const Text('Publicar tema'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}