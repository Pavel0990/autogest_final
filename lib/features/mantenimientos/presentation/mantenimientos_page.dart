import 'package:flutter/material.dart';
import '../data/mantenimientos_service.dart';
import '../models/mantenimiento_model.dart';
import 'crear_mantenimiento_page.dart';
import 'mantenimiento_detalle_page.dart';

class MantenimientosPage extends StatefulWidget {
  final int vehiculoId;

  const MantenimientosPage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<MantenimientosPage> createState() => _MantenimientosPageState();
}

class _MantenimientosPageState extends State<MantenimientosPage> {
  final MantenimientosService service = MantenimientosService();
  late Future<List<MantenimientoModel>> futureMantenimientos;

  @override
  void initState() {
    super.initState();
    futureMantenimientos = service.getMantenimientos(
      vehiculoId: widget.vehiculoId,
    );
  }

  Future<void> recargar() async {
    setState(() {
      futureMantenimientos = service.getMantenimientos(
        vehiculoId: widget.vehiculoId,
      );
    });
  }

  Future<void> abrirCrearMantenimiento() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearMantenimientoPage(
          vehiculoId: widget.vehiculoId,
        ),
      ),
    );

    if (creado == true) {
      await recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimientos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrearMantenimiento,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<MantenimientoModel>>(
        future: futureMantenimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final mantenimientos = snapshot.data ?? [];

          if (mantenimientos.isEmpty) {
            return const Center(
              child: Text('No hay mantenimientos registrados'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: mantenimientos.length,
              itemBuilder: (context, index) {
                final m = mantenimientos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(m.tipo),
                    subtitle: Text('Costo: RD\$ ${m.costo}\nFecha: ${m.fecha}'),
                    isThreeLine: true,
                    trailing: Text('${m.fotos.length} fotos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MantenimientoDetallePage(
                            mantenimientoId: m.id,
                          ),
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