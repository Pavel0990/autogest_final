class Noticia {
  final int id;
  final String titulo;
  final String resumen;
  final String imagen;
  final String fecha;
  final String fuente;
  final String link;

  Noticia({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.imagen,
    required this.fecha,
    required this.fuente,
    required this.link,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'] ?? '',
      imagen: json['imagenUrl'] ?? '',
      fecha: json['fecha'] ?? '',
      fuente: json['fuente'] ?? '',
      link: json['link'] ?? '',
    );
  }
}