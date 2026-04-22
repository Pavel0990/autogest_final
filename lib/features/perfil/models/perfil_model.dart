class PerfilModel {
  final int id;
  final String matricula;
  final String nombre;
  final String apellido;
  final String correo;
  final String fotoUrl;
  final String rol;
  final String grupo;

  PerfilModel({
    required this.id,
    required this.matricula,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.fotoUrl,
    required this.rol,
    required this.grupo,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      id: json['id'] ?? 0,
      matricula: json['matricula'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      fotoUrl: json['fotoUrl'] ?? json['foto_url'] ?? '',
      rol: json['rol'] ?? '',
      grupo: json['grupo'] ?? '',
    );
  }
}