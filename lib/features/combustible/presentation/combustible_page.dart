import 'package:flutter/material.dart';
import '../data/combustible_service.dart';
import '../models/combustible_model.dart';
import 'crear_combustible_page.dart';

class CombustiblePage extends StatefulWidget {
  final int vehiculoId;

  const CombustiblePage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<CombustiblePage> createState() => _CombustiblePageState();
}

class _CombustiblePageState extends State<CombustiblePage> {
  final CombustibleService service = CombustibleService();
  late Future<List<CombustibleModel>> futureRegistros;

  @override
  void initState() {
    super.initState();
    futureRegistros = service.getRegistros(widget.vehiculoId);
  }

  Future<void> recargar() async {
    setState(() {
      futureRegistros = service.getRegistros(widget.vehiculoId);
    });
  }

  Future<void> abrirCrear() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearCombustiblePage(
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
        title: const Text('Combustible'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrear,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<CombustibleModel>>(
        future: futureRegistros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('No hay registros de combustible'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) {
                final c = data[i];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.local_gas_station),
                    title: Text('${c.cantidad} ${c.unidad}'),
                    subtitle: Text('RD\$ ${c.monto} | ${c.fecha}'),
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