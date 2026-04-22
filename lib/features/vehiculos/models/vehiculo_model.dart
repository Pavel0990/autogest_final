class VehiculoModel {
  final int id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String fotoUrl;
  final String fechaRegistro;

  VehiculoModel({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    required this.fotoUrl,
    required this.fechaRegistro,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      id: json['id'] ?? 0,
      placa: json['placa'] ?? '',
      chasis: json['chasis'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: json['anio'] ?? 0,
      cantidadRuedas: json['cantidadRuedas'] ?? json['cantidad_ruedas'] ?? 0,
      fotoUrl: json['fotoUrl'] ?? json['foto_url'] ?? '',
      fechaRegistro: json['fechaRegistro'] ?? json['fecha_registro'] ?? '',
    );
  }
}