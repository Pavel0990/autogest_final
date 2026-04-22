import 'package:flutter/material.dart';

class CrearMantenimientoPage extends StatelessWidget {
  final int vehiculoId;

  const CrearMantenimientoPage({super.key, required this.vehiculoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear mantenimiento')),
      body: const Center(
        child: Text('Pantalla en construcción'),
      ),
    );
  }
}