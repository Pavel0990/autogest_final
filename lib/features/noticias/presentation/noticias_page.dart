import 'package:flutter/material.dart';
import '../../vehiculos/data/data/noticias_service.dart';
import '../models/noticia_model.dart';
import 'noticia_detalle_page.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  final NoticiasService service = NoticiasService();
  late Future<List<Noticia>> futureNoticias;

  @override
  void initState() {
    super.initState();
    futureNoticias = service.getNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias Automotrices'),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: futureNoticias,
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

          final noticias = snapshot.data ?? [];

          if (noticias.isEmpty) {
            return const Center(
              child: Text('No hay noticias disponibles'),
            );
          }

          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: noticia.imagen.isNotEmpty
                      ? Image.network(
                          noticia.imagen,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : const Icon(Icons.image),
                  title: Text(noticia.titulo),
                  subtitle: Text(noticia.resumen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoticiaDetallePage(
                          noticiaId: noticia.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}