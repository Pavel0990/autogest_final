class CombustibleModel {
  final int id;
  final int vehiculoId;
  final String tipo;
  final num cantidad;
  final String unidad;
  final num monto;
  final String fecha;

  CombustibleModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.monto,
    required this.fecha,
  });

  factory CombustibleModel.fromJson(Map<String, dynamic> json) {
    return CombustibleModel(
      id: json['id'] ?? 0,
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'] ?? 0,
      tipo: json['tipo'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      unidad: json['unidad'] ?? '',
      monto: json['monto'] ?? 0,
      fecha: json['fecha'] ?? '',
    );
  }
}