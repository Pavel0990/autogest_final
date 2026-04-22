import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/gasto_model.dart';

class GastosService {
  final ApiClient apiClient = ApiClient();

  Future<List<GastoCategoriaModel>> getCategorias() async {
    try {
      final response = await apiClient.dio.get(
        'gastos/categorias',
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
              .map((e) => GastoCategoriaModel.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<GastoModel>> getGastos(int vehiculoId) async {
    try {
      final response = await apiClient.dio.get(
        'gastos',
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
          return rawData.map((e) => GastoModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> crearGasto({
    required int vehiculoId,
    required int categoriaId,
    required num monto,
    required String fecha,
    required String descripcion,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'gastos',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'vehiculo_id': vehiculoId,
            'categoria_id': categoriaId,
            'monto': monto,
            'fecha': fecha,
            'descripcion': descripcion,
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
          body['message']?.toString() ?? 'Error al registrar gasto',
        );
      }

      throw Exception('Error al registrar gasto');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw Exception(
          data['message']?.toString() ?? 'Error al registrar gasto',
        );
      }

      throw Exception('Error al registrar gasto');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al registrar gasto');
    }
  }
}