import 'package:flutter/material.dart';
import '../data/gastos_service.dart';
import '../models/gasto_model.dart';

class CrearGastoPage extends StatefulWidget {
  final int vehiculoId;

  const CrearGastoPage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<CrearGastoPage> createState() => _CrearGastoPageState();
}

class _CrearGastoPageState extends State<CrearGastoPage> {
  final GastosService service = GastosService();

  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  bool isLoading = false;
  bool isLoadingCategorias = true;

  List<GastoCategoriaModel> categorias = [];
  int? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    final data = await service.getCategorias();

    if (!mounted) return;

    setState(() {
      categorias = data;
      if (categorias.isNotEmpty) {
        categoriaSeleccionada = categorias.first.id;
      }
      isLoadingCategorias = false;
    });
  }

  Future<void> guardar() async {
    final monto = num.tryParse(montoController.text.trim());
    final fecha = fechaController.text.trim();
    final descripcion = descripcionController.text.trim();

    if (categoriaSeleccionada == null || monto == null || fecha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa categoría, monto y fecha'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await service.crearGasto(
        vehiculoId: widget.vehiculoId,
        categoriaId: categoriaSeleccionada!,
        monto: monto,
        fecha: fecha,
        descripcion: descripcion,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gasto registrado satisfactoriamente'),
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
        title: const Text('Registrar gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoadingCategorias
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: categoriaSeleccionada,
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<int>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        categoriaSeleccionada = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monto',
                      hintText: 'Ej. 1500',
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
                      hintText: 'Ej. Seguro, lavado, multa...',
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
                          : const Text('Guardar gasto'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}