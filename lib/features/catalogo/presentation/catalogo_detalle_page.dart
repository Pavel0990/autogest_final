import 'package:flutter/material.dart';
import '../data/catalogo_service.dart';
import '../models/catalogo_model.dart';

class CatalogoDetallePage extends StatefulWidget {
  final int vehiculoId;

  const CatalogoDetallePage({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<CatalogoDetallePage> createState() => _CatalogoDetallePageState();
}

class _CatalogoDetallePageState extends State<CatalogoDetallePage> {
  final CatalogoService service = CatalogoService();
  late Future<CatalogoVehiculoDetalleModel> futureDetalle;

  @override
  void initState() {
    super.initState();
    futureDetalle = service.getDetalle(widget.vehiculoId);
  }

  Widget specTile(String key, String value) {
    return Card(
      child: ListTile(
        title: Text(key),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del catálogo'),
      ),
      body: FutureBuilder<CatalogoVehiculoDetalleModel>(
        future: futureDetalle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se pudo cargar el detalle'),
            );
          }

          final vehiculo = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vehiculo.imagenes.isNotEmpty)
                  SizedBox(
                    height: 230,
                    child: PageView.builder(
                      itemCount: vehiculo.imagenes.length,
                      itemBuilder: (context, index) {
                        final image = vehiculo.imagenes[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.directions_car, size: 80),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  '${vehiculo.marca} ${vehiculo.modelo}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Año: ${vehiculo.anio}'),
                Text('Precio: RD\$ ${vehiculo.precio}'),
                const SizedBox(height: 12),
                Text(vehiculo.descripcion),
                const SizedBox(height: 20),
                const Text(
                  'Especificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (vehiculo.especificaciones.isEmpty)
                  const Text('No hay especificaciones disponibles')
                else
                  ...vehiculo.especificaciones.entries.map(
                    (e) => specTile(e.key, e.value.toString()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}