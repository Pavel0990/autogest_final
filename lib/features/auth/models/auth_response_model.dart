class AuthResponseModel {
  final int id;
  final String? matricula;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String? fotoUrl;
  final String? token;
  final String? refreshToken;

  AuthResponseModel({
    required this.id,
    this.matricula,
    this.nombre,
    this.apellido,
    this.correo,
    this.fotoUrl,
    this.token,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: json['id'] ?? 0,
      matricula: json['matricula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      fotoUrl: json['fotoUrl'],
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}