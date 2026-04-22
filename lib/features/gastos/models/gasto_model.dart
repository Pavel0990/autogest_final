class GastoModel {
  final int id;
  final int vehiculoId;
  final int categoriaId;
  final String categoriaNombre;
  final num monto;
  final String fecha;
  final String descripcion;

  GastoModel({
    required this.id,
    required this.vehiculoId,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.monto,
    required this.fecha,
    required this.descripcion,
  });

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    return GastoModel(
      id: json['id'] ?? 0,
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'] ?? 0,
      categoriaId: json['categoria_id'] ?? json['categoriaId'] ?? 0,
      categoriaNombre:
          json['categoriaNombre'] ??
          json['categoria_nombre'] ??
          json['categoria'] ??
          '',
      monto: json['monto'] ?? 0,
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
}

class GastoCategoriaModel {
  final int id;
  final String nombre;

  GastoCategoriaModel({
    required this.id,
    required this.nombre,
  });

  factory GastoCategoriaModel.fromJson(Map<String, dynamic> json) {
    return GastoCategoriaModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}