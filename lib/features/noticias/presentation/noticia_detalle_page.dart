import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../vehiculos/data/data/noticias_service.dart';
import '../models/noticia_detalle_model.dart';

class NoticiaDetallePage extends StatefulWidget {
  final int noticiaId;

  const NoticiaDetallePage({
    super.key,
    required this.noticiaId,
  });

  @override
  State<NoticiaDetallePage> createState() => _NoticiaDetallePageState();
}

class _NoticiaDetallePageState extends State<NoticiaDetallePage> {
  final NoticiasService service = NoticiasService();
  late Future<NoticiaDetalle> futureDetalle;

  @override
  void initState() {
    super.initState();
    futureDetalle = service.getNoticiaDetalle(widget.noticiaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de noticia'),
      ),
      body: FutureBuilder<NoticiaDetalle>(
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
              child: Text('No se pudo cargar la noticia'),
            );
          }

          final noticia = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (noticia.imagen.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      noticia.imagen,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  noticia.titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  noticia.fecha,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                if (noticia.resumen.isNotEmpty)
                  Text(
                    noticia.resumen,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 16),
                Html(data: noticia.contenido),
              ],
            ),
          );
        },
      ),
    );
  }
}