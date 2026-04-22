import '../../../core/api/api_client.dart';
import '../models/video_model.dart';

class VideosService {
  final ApiClient apiClient = ApiClient();

  Future<List<VideoModel>> getVideos() async {
    try {
      final response = await apiClient.dio.get('videos');
      final List data = response.data['data'];
      return data.map((json) => VideoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar videos');
    }
  }
}