class CatalogoVehiculoModel {
  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final num precio;
  final String descripcion;
  final String imagenUrl;

  CatalogoVehiculoModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.descripcion,
    required this.imagenUrl,
  });

  factory CatalogoVehiculoModel.fromJson(Map<String, dynamic> json) {
    return CatalogoVehiculoModel(
      id: json['id'] ?? 0,
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: json['anio'] ?? 0,
      precio: json['precio'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      imagenUrl: json['imagenUrl'] ?? json['imagen_url'] ?? '',
    );
  }
}

class CatalogoVehiculoDetalleModel {
  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final num precio;
  final String descripcion;
  final List<String> imagenes;
  final Map<String, dynamic> especificaciones;

  CatalogoVehiculoDetalleModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.descripcion,
    required this.imagenes,
    required this.especificaciones,
  });

  factory CatalogoVehiculoDetalleModel.fromJson(Map<String, dynamic> json) {
    return CatalogoVehiculoDetalleModel(
      id: json['id'] ?? 0,
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: json['anio'] ?? 0,
      precio: json['precio'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      imagenes: (json['imagenes'] as List?)?.map((e) => e.toString()).toList() ??
          (json['galeria'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      especificaciones: (json['especificaciones'] as Map<String, dynamic>?) ?? {},
    );
  }
}