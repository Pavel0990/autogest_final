import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/combustible_model.dart';

class CombustibleService {
  final ApiClient apiClient = ApiClient();

  Future<List<CombustibleModel>> getRegistros(int vehiculoId) async {
    try {
      final response = await apiClient.dio.get(
        'combustibles',
        queryParameters: {
          'vehiculo_id': vehiculoId,
        },
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 && body is Map<String, dynamic>) {
        final dynamic rawData = body['data'];

        if (rawData is List) {
          return rawData
              .map((e) => CombustibleModel.fromJson(e))
              .where((e) => e.tipo.toLowerCase() == 'combustible')
              .toList();
        }

        return [];
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> crearRegistro({
    required int vehiculoId,
    required String tipo,
    required num cantidad,
    required String unidad,
    required num monto,
    required String fecha,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'combustibles',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'vehiculo_id': vehiculoId,
            'tipo': 'combustible',
            'cantidad': cantidad,
            'unidad': unidad,
            'monto': monto,
            'fecha': fecha,
          }),
        }),
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 || status == 201) {
        return;
      }

      if (body is Map<String, dynamic>) {
        throw Exception(
          body['message']?.toString() ?? 'Error al registrar combustible',
        );
      }

      throw Exception('Error al registrar combustible');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw Exception(
          data['message']?.toString() ?? 'Error al registrar combustible',
        );
      }
      throw Exception('Error al registrar combustible');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al registrar combustible');
    }
  }
}