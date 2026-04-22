class ForoTemaModel {
  final int id;
  final int vehiculoId;
  final String titulo;
  final String descripcion;
  final String autor;
  final String fecha;
  final String fotoVehiculo;
  final int respuestas;

  ForoTemaModel({
    required this.id,
    required this.vehiculoId,
    required this.titulo,
    required this.descripcion,
    required this.autor,
    required this.fecha,
    required this.fotoVehiculo,
    required this.respuestas,
  });

  factory ForoTemaModel.fromJson(Map<String, dynamic> json) {
    return ForoTemaModel(
      id: json['id'] ?? 0,
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      autor: json['autor'] ?? json['nombre'] ?? '',
      fecha: json['fecha'] ?? '',
      fotoVehiculo: json['fotoVehiculo'] ?? json['foto_vehiculo'] ?? '',
      respuestas: json['respuestas'] ?? json['cantidad_respuestas'] ?? 0,
    );
  }
}

class ForoRespuestaModel {
  final int id;
  final String contenido;
  final String autor;
  final String fecha;

  ForoRespuestaModel({
    required this.id,
    required this.contenido,
    required this.autor,
    required this.fecha,
  });

  factory ForoRespuestaModel.fromJson(Map<String, dynamic> json) {
    return ForoRespuestaModel(
      id: json['id'] ?? 0,
      contenido: json['contenido'] ?? '',
      autor: json['autor'] ?? json['nombre'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}

class ForoDetalleModel {
  final ForoTemaModel tema;
  final List<ForoRespuestaModel> respuestas;

  ForoDetalleModel({
    required this.tema,
    required this.respuestas,
  });

  factory ForoDetalleModel.fromJson(Map<String, dynamic> json) {
    final temaJson = json['tema'] ?? json;
    final respuestasJson = json['respuestas'] as List? ?? [];

    return ForoDetalleModel(
      tema: ForoTemaModel.fromJson(temaJson),
      respuestas: respuestasJson
          .map((e) => ForoRespuestaModel.fromJson(e))
          .toList(),
    );
  }
}