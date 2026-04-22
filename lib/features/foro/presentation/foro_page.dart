import 'package:flutter/material.dart';
import '../data/foro_service.dart';
import '../models/foro_model.dart';
import 'crear_tema_page.dart';
import 'foro_detalle_page.dart';

class ForoPage extends StatefulWidget {
  const ForoPage({super.key});

  @override
  State<ForoPage> createState() => _ForoPageState();
}

class _ForoPageState extends State<ForoPage> {
  final ForoService service = ForoService();
  late Future<List<ForoTemaModel>> futureTemas;

  @override
  void initState() {
    super.initState();
    futureTemas = service.getTemas();
  }

  Future<void> recargar() async {
    setState(() {
      futureTemas = service.getTemas();
    });
  }

  Future<void> abrirCrearTema() async {
    final creado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CrearTemaPage(),
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
        title: const Text('Foro'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCrearTema,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ForoTemaModel>>(
        future: futureTemas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final temas = snapshot.data ?? [];

          if (temas.isEmpty) {
            return const Center(
              child: Text('No hay temas en el foro'),
            );
          }

          return RefreshIndicator(
            onRefresh: recargar,
            child: ListView.builder(
              itemCount: temas.length,
              itemBuilder: (context, index) {
                final tema = temas[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: tema.fotoVehiculo.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              tema.fotoVehiculo,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.forum),
                            ),
                          )
                        : const Icon(Icons.forum),
                    title: Text(tema.titulo),
                    subtitle: Text(
                      '${tema.autor}\n${tema.descripcion}',
                    ),
                    isThreeLine: true,
                    trailing: Text('${tema.respuestas} resp.'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForoDetallePage(temaId: tema.id),
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