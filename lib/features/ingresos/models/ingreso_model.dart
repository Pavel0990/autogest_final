class IngresoModel {
  final int id;
  final int vehiculoId;
  final num monto;
  final String fecha;
  final String descripcion;

  IngresoModel({
    required this.id,
    required this.vehiculoId,
    required this.monto,
    required this.fecha,
    required this.descripcion,
  });

  factory IngresoModel.fromJson(Map<String, dynamic> json) {
    return IngresoModel(
      id: json['id'] ?? 0,
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'] ?? 0,
      monto: json['monto'] ?? 0,
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
}