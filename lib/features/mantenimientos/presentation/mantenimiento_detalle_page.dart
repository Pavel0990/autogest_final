import 'package:flutter/material.dart';

class MantenimientoDetallePage extends StatelessWidget {
  final int mantenimientoId;

  const MantenimientoDetallePage({
    super.key,
    required this.mantenimientoId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle mantenimiento')),
      body: Center(
        child: Text('ID: $mantenimientoId'),
      ),
    );
  }
}