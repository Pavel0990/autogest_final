import 'package:flutter/material.dart';
import '../data/foro_service.dart';
import '../models/foro_model.dart';

class ForoDetallePage extends StatefulWidget {
  final int temaId;

  const ForoDetallePage({
    super.key,
    required this.temaId,
  });

  @override
  State<ForoDetallePage> createState() => _ForoDetallePageState();
}

class _ForoDetallePageState extends State<ForoDetallePage> {
  final ForoService service = ForoService();
  final TextEditingController respuestaController = TextEditingController();

  late Future<ForoDetalleModel> futureDetalle;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    futureDetalle = service.getDetalle(widget.temaId);
  }

  Future<void> recargar() async {
    setState(() {
      futureDetalle = service.getDetalle(widget.temaId);
    });
  }

  Future<void> responder() async {
    final contenido = respuestaController.text.trim();

    if (contenido.isEmpty) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await service.responderTema(
        temaId: widget.temaId,
        contenido: contenido,
      );

      respuestaController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuesta enviada')),
      );

      await recargar();
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
          isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    respuestaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema del foro'),
      ),
      body: FutureBuilder<ForoDetalleModel>(
        future: futureDetalle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se pudo cargar el tema'),
            );
          }

          final detalle = snapshot.data!;
          final tema = detalle.tema;
          final respuestas = detalle.respuestas;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      tema.titulo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${tema.autor} · ${tema.fecha}'),
                    const SizedBox(height: 12),
                    Text(tema.descripcion),
                    const SizedBox(height: 20),
                    const Text(
                      'Respuestas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (respuestas.isEmpty)
                      const Text('No hay respuestas todavía')
                    else
                      ...respuestas.map((r) {
                        return Card(
                          child: ListTile(
                            title: Text(r.autor),
                            subtitle: Text('${r.contenido}\n${r.fecha}'),
                            isThreeLine: true,
                          ),
                        );
                      }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: respuestaController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe una respuesta',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: isSending ? null : responder,
                      icon: isSending
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}