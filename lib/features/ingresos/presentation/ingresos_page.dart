import 'package:flutter/material.dart';
import '../data/ingresos_service.dart';
import '../models/ingreso_model.dart';
import 'crear_ingreso_page.dart';

class IngresosPage extends StatefulWidget {
  final int vehiculoId;

  const IngresosPage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<IngresosPage> createState() => _IngresosPageState();
}

class _IngresosPageState extends State<IngresosPage> {
  final IngresosService service = IngresosService();
  late Future<List<IngresoModel>> futureIngresos;

  @override
  void initState() {
    super.initState();
    futureIngresos = service.getIngresos(widget.vehiculoId);
  }

  Future<void> recargar() async {
    setState(() {
      futureIngresos = service.getIngresos(widget.vehiculoId);
    });
  }

  Future<void> abrirCrear() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearIngresoPage(
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
        title: const Text('Ingresos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrear,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<IngresoModel>>(
        future: futureIngresos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('No hay ingresos registrados'),
            );
          }

          final ingresos = snapshot.data ?? [];

          if (ingresos.isEmpty) {
            return const Center(
              child: Text('No hay ingresos registrados'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: ingresos.length,
              itemBuilder: (context, index) {
                final i = ingresos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Ingreso'),
                    subtitle: Text(
                      'RD\$ ${i.monto}\n${i.fecha}\n${i.descripcion}',
                    ),
                    isThreeLine: true,
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