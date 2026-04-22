import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/mantenimiento_model.dart';

class MantenimientosService {
  final ApiClient apiClient = ApiClient();

  Future<List<MantenimientoModel>> getMantenimientos({
    required int vehiculoId,
  }) async {
    try {
      final response = await apiClient.dio.get(
        'mantenimientos',
        queryParameters: {
          'vehiculo_id': vehiculoId,
        },
        options: Options(validateStatus: (_) => true),
      );

      final body = response.data;

      if (body is Map && body['data'] is List) {
        return (body['data'] as List)
            .map((e) => MantenimientoModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }
}