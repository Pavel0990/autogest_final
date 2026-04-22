class MantenimientoModel {
  final int id;
  final int vehiculoId;
  final String tipo;
  final num costo;
  final String fecha;
  final List fotos;

  MantenimientoModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.costo,
    required this.fecha,
    required this.fotos,
  });

  factory MantenimientoModel.fromJson(Map<String, dynamic> json) {
    return MantenimientoModel(
      id: json['id'] ?? 0,
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'] ?? 0,
      tipo: json['tipo'] ?? '',
      costo: json['costo'] ?? 0,
      fecha: json['fecha'] ?? '',
      fotos: json['fotos'] ?? [],
    );
  }
}