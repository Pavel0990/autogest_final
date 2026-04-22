import '../../../core/api/api_client.dart';
import '../models/noticia_detalle_model.dart';
import '../models/noticia_model.dart';

class NoticiasService {
  final ApiClient apiClient = ApiClient();

  Future<List<Noticia>> getNoticias() async {
    try {
      final response = await apiClient.dio.get('noticias');

      final List data = response.data['data'];
      return data.map((e) => Noticia.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al cargar noticias');
    }
  }

  Future<NoticiaDetalle> getNoticiaDetalle(int id) async {
    try {
      final response = await apiClient.dio.get(
        'noticias/detalle',
        queryParameters: {'id': id},
      );

      final data = response.data['data'];
      return NoticiaDetalle.fromJson(data);
    } catch (e) {
      throw Exception('Error al cargar detalle de la noticia');
    }
  }
}