import 'package:flutter/material.dart';
import '../data/catalogo_service.dart';
import '../models/catalogo_model.dart';
import 'catalogo_detalle_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final CatalogoService service = CatalogoService();

  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anioController = TextEditingController();
  final TextEditingController precioMinController = TextEditingController();
  final TextEditingController precioMaxController = TextEditingController();

  late Future<List<CatalogoVehiculoModel>> futureCatalogo;

  @override
  void initState() {
    super.initState();
    futureCatalogo = service.getCatalogo();
  }

  Future<void> buscar() async {
    setState(() {
      futureCatalogo = service.getCatalogo(
        marca: marcaController.text,
        modelo: modeloController.text,
        anio: anioController.text,
        precioMin: precioMinController.text,
        precioMax: precioMaxController.text,
      );
    });
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    anioController.dispose();
    precioMinController.dispose();
    precioMaxController.dispose();
    super.dispose();
  }

  Widget filtroField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                filtroField(marcaController, 'Marca'),
                const SizedBox(height: 8),
                filtroField(modeloController, 'Modelo'),
                const SizedBox(height: 8),
                filtroField(anioController, 'Año'),
                const SizedBox(height: 8),
                filtroField(precioMinController, 'Precio mínimo'),
                const SizedBox(height: 8),
                filtroField(precioMaxController, 'Precio máximo'),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buscar,
                    child: const Text('Buscar'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CatalogoVehiculoModel>>(
              future: futureCatalogo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vehiculos = snapshot.data ?? [];

                if (vehiculos.isEmpty) {
                  return const Center(
                    child: Text('No hay vehículos en el catálogo'),
                  );
                }

                return ListView.builder(
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    final vehiculo = vehiculos[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: vehiculo.imagenUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  vehiculo.imagenUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.directions_car),
                                ),
                              )
                            : const Icon(Icons.directions_car),
                        title: Text('${vehiculo.marca} ${vehiculo.modelo}'),
                        subtitle: Text(
                          'Año: ${vehiculo.anio}\nRD\$ ${vehiculo.precio}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CatalogoDetallePage(
                                vehiculoId: vehiculo.id,
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
          ),
        ],
      ),
    );
  }
}