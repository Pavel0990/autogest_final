class VehiculoDetalleModel {
  final int id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String fotoUrl;
  final String fechaRegistro;
  final VehiculoResumenModel resumen;

  VehiculoDetalleModel({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    required this.fotoUrl,
    required this.fechaRegistro,
    required this.resumen,
  });

  factory VehiculoDetalleModel.fromJson(Map<String, dynamic> json) {
    return VehiculoDetalleModel(
      id: json['id'] ?? 0,
      placa: json['placa'] ?? '',
      chasis: json['chasis'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: json['anio'] ?? 0,
      cantidadRuedas: json['cantidadRuedas'] ?? json['cantidad_ruedas'] ?? 0,
      fotoUrl: json['fotoUrl'] ?? json['foto_url'] ?? '',
      fechaRegistro: json['fechaRegistro'] ?? json['fecha_registro'] ?? '',
      resumen: VehiculoResumenModel.fromJson(json['resumen'] ?? {}),
    );
  }
}

class VehiculoResumenModel {
  final num totalMantenimientos;
  final num totalCombustible;
  final num totalGastos;
  final num totalIngresos;
  final num totalInvertido;
  final num balance;

  VehiculoResumenModel({
    required this.totalMantenimientos,
    required this.totalCombustible,
    required this.totalGastos,
    required this.totalIngresos,
    required this.totalInvertido,
    required this.balance,
  });

  factory VehiculoResumenModel.fromJson(Map<String, dynamic> json) {
    return VehiculoResumenModel(
      totalMantenimientos:
          json['totalMantenimientos'] ??
          json['total_mantenimientos'] ??
          0,
      totalCombustible:
          json['totalCombustible'] ??
          json['total_combustible'] ??
          0,
      totalGastos:
          json['totalGastos'] ??
          json['total_gastos'] ??
          0,
      totalIngresos:
          json['totalIngresos'] ??
          json['total_ingresos'] ??
          0,
      totalInvertido:
          json['totalInvertido'] ??
          json['total_invertido'] ??
          0,
      balance: json['balance'] ?? 0,
    );
  }
}