import 'package:flutter/material.dart';
import '../data/gastos_service.dart';
import '../models/gasto_model.dart';
import 'crear_gasto_page.dart';

class GastosPage extends StatefulWidget {
  final int vehiculoId;

  const GastosPage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  final GastosService service = GastosService();
  late Future<List<GastoModel>> futureGastos;

  @override
  void initState() {
    super.initState();
    futureGastos = service.getGastos(widget.vehiculoId);
  }

  Future<void> recargar() async {
    setState(() {
      futureGastos = service.getGastos(widget.vehiculoId);
    });
  }

  Future<void> abrirCrear() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearGastoPage(
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
        title: const Text('Gastos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrear,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<GastoModel>>(
        future: futureGastos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('No hay gastos registrados'),
            );
          }

          final gastos = snapshot.data ?? [];

          if (gastos.isEmpty) {
            return const Center(
              child: Text('No hay gastos registrados'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final g = gastos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.money_off),
                    title: Text(g.categoriaNombre.isEmpty
                        ? 'Gasto'
                        : g.categoriaNombre),
                    subtitle: Text(
                      'RD\$ ${g.monto}\n${g.fecha}\n${g.descripcion}',
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