import 'package:flutter/material.dart';
import '../data/vehiculos_service.dart';
import '../models/vehiculo_model.dart';
import 'crear_vehiculo_page.dart';
import 'vehiculo_detalle_page.dart';

class VehiculosPage extends StatefulWidget {
  const VehiculosPage({super.key});

  @override
  State<VehiculosPage> createState() => _VehiculosPageState();
}

class _VehiculosPageState extends State<VehiculosPage> {
  final VehiculosService service = VehiculosService();
  late Future<List<VehiculoModel>> futureVehiculos;

  @override
  void initState() {
    super.initState();
    futureVehiculos = service.getVehiculos();
  }

  Future<void> recargar() async {
    setState(() {
      futureVehiculos = service.getVehiculos();
    });
  }

  Future<void> abrirCrearVehiculo() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CrearVehiculoPage(),
      ),
    );

    if (creado == true) {
      recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrearVehiculo,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<VehiculoModel>>(
        future: futureVehiculos,
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

          final vehiculos = snapshot.data ?? [];

          if (vehiculos.isEmpty) {
            return const Center(
              child: Text('No tienes vehículos registrados'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final v = vehiculos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: v.fotoUrl.isNotEmpty
                        ? Image.network(
                            v.fotoUrl,
                            width: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.directions_car),
                          )
                        : const Icon(Icons.directions_car),
                    title: Text('${v.marca} ${v.modelo}'),
                    subtitle: Text('Placa: ${v.placa}\nAño: ${v.anio}'),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VehiculoDetallePage(vehiculoId: v.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}