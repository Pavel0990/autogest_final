class NoticiaDetalle {
  final int id;
  final String titulo;
  final String resumen;
  final String contenido;
  final String imagen;
  final String fecha;
  final String fuente;
  final String link;

  NoticiaDetalle({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.contenido,
    required this.imagen,
    required this.fecha,
    required this.fuente,
    required this.link,
  });

  factory NoticiaDetalle.fromJson(Map<String, dynamic> json) {
    return NoticiaDetalle(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'] ?? '',
      contenido: json['contenido'] ?? '',
      imagen: json['imagenUrl'] ?? '',
      fecha: json['fecha'] ?? '',
      fuente: json['fuente'] ?? '',
      link: json['link'] ?? '',
    );
  }
}