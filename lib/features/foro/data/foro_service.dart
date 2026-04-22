import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/foro_model.dart';

class ForoService {
  final ApiClient apiClient = ApiClient();

  Future<List<ForoTemaModel>> getTemas() async {
    try {
      final response = await apiClient.dio.get(
        'foro/temas',
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 && body is Map<String, dynamic>) {
        final rawData = body['data'];

        if (rawData is List) {
          return rawData.map((e) => ForoTemaModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<ForoDetalleModel> getDetalle(int id) async {
    try {
      final response = await apiClient.dio.get(
        'foro/detalle',
        queryParameters: {'id': id},
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 && body is Map<String, dynamic>) {
        return ForoDetalleModel.fromJson(body['data'] ?? {});
      }

      if (body is Map<String, dynamic>) {
        throw Exception(body['message']?.toString() ?? 'Error al cargar tema');
      }

      throw Exception('Error al cargar tema');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw Exception(data['message']?.toString() ?? 'Error al cargar tema');
      }
      throw Exception('Error al cargar tema');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al cargar tema');
    }
  }

  Future<void> crearTema({
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'foro/crear',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'vehiculo_id': vehiculoId,
            'titulo': titulo,
            'descripcion': descripcion,
          }),
        }),
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 || status == 201) return;

      if (body is Map<String, dynamic>) {
        throw Exception(body['message']?.toString() ?? 'Error al crear tema');
      }

      throw Exception('Error al crear tema');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw Exception(data['message']?.toString() ?? 'Error al crear tema');
      }
      throw Exception('Error al crear tema');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al crear tema');
    }
  }

  Future<void> responderTema({
    required int temaId,
    required String contenido,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'foro/responder',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'tema_id': temaId,
            'contenido': contenido,
          }),
        }),
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 || status == 201) return;

      if (body is Map<String, dynamic>) {
        throw Exception(body['message']?.toString() ?? 'Error al responder');
      }

      throw Exception('Error al responder');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw Exception(data['message']?.toString() ?? 'Error al responder');
      }
      throw Exception('Error al responder');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al responder');
    }
  }
}