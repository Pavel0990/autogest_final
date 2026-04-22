import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/vehiculos_service.dart';
import '../models/vehiculo_detalle_model.dart';
import 'editar_vehiculo_page.dart';
import '../../mantenimientos/presentation/mantenimientos_page.dart';
import '../../combustible/presentation/combustible_page.dart';
import '../../gastos/presentation/gastos_page.dart';
import '../../ingresos/presentation/ingresos_page.dart';

class VehiculoDetallePage extends StatefulWidget {
  final int vehiculoId;

  const VehiculoDetallePage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<VehiculoDetallePage> createState() => _VehiculoDetallePageState();
}

class _VehiculoDetallePageState extends State<VehiculoDetallePage> {
  final VehiculosService service = VehiculosService();
  final ImagePicker picker = ImagePicker();

  late Future<VehiculoDetalleModel> futureDetalle;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    futureDetalle = service.getVehiculoDetalle(widget.vehiculoId);
  }

  Future<void> recargarDetalle() async {
    setState(() {
      futureDetalle = service.getVehiculoDetalle(widget.vehiculoId);
    });
  }

  Future<void> seleccionarYSubirFoto() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      await service.subirFotoVehiculo(
        vehiculoId: widget.vehiculoId,
        imageFile: File(pickedFile.path),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto actualizada correctamente')),
      );

      await recargarDetalle();
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
          isUploading = false;
        });
      }
    }
  }

  Future<void> abrirEditarVehiculo(VehiculoDetalleModel vehiculo) async {
    final actualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarVehiculoPage(vehiculo: vehiculo),
      ),
    );

    if (actualizado == true) {
      await recargarDetalle();
    }
  }

  Widget resumenTile(String titulo, num valor) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Vehículo'),
        actions: [
          IconButton(
            onPressed: isUploading ? null : seleccionarYSubirFoto,
            icon: isUploading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.photo_camera),
          ),
        ],
      ),
      body: FutureBuilder<VehiculoDetalleModel>(
        future: futureDetalle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se pudo cargar el vehículo'),
            );
          }

          final vehiculo = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vehiculo.fotoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      vehiculo.fotoUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.directions_car, size: 80),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 220,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_car, size: 80),
                  ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${vehiculo.marca} ${vehiculo.modelo}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => abrirEditarVehiculo(vehiculo),
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text('Placa: ${vehiculo.placa}'),
                Text('Chasis: ${vehiculo.chasis}'),
                Text('Año: ${vehiculo.anio}'),
                Text('Cantidad de ruedas: ${vehiculo.cantidadRuedas}'),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MantenimientosPage(
                            vehiculoId: vehiculo.id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.build),
                    label: const Text('Ver mantenimientos'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final actualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CombustiblePage(
                            vehiculoId: vehiculo.id,
                          ),
                        ),
                      );

                      if (actualizado == true) {
                        await recargarDetalle();
                      }
                    },
                    icon: const Icon(Icons.local_gas_station),
                    label: const Text('Combustible'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final actualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GastosPage(
                            vehiculoId: vehiculo.id,
                          ),
                        ),
                      );

                      if (actualizado == true) {
                        await recargarDetalle();
                      }
                    },
                    icon: const Icon(Icons.money_off),
                    label: const Text('Gastos'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final actualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IngresosPage(
                            vehiculoId: vehiculo.id,
                          ),
                        ),
                      );

                      if (actualizado == true) {
                        await recargarDetalle();
                      }
                    },
                    icon: const Icon(Icons.attach_money),
                    label: const Text('Ingresos'),
                  ),
                ),

               

                const SizedBox(height: 20),

                const Text(
                  'Resumen financiero',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                resumenTile(
                  'Total mantenimientos',
                  vehiculo.resumen.totalMantenimientos,
                ),
                resumenTile(
                  'Total combustible',
                  vehiculo.resumen.totalCombustible,
                ),
                resumenTile(
                  'Total gastos',
                  vehiculo.resumen.totalGastos,
                ),
                resumenTile(
                  'Total ingresos',
                  vehiculo.resumen.totalIngresos,
                ),
                resumenTile(
                  'Total invertido',
                  vehiculo.resumen.totalInvertido,
                ),
                resumenTile(
                  'Balance',
                  vehiculo.resumen.balance,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}