import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/catalogo_model.dart';

class CatalogoService {
  final ApiClient apiClient = ApiClient();

  Future<List<CatalogoVehiculoModel>> getCatalogo({
    String? marca,
    String? modelo,
    String? anio,
    String? precioMin,
    String? precioMax,
  }) async {
    try {
      final response = await apiClient.dio.get(
        'catalogo',
        queryParameters: {
          if (marca?.trim().isNotEmpty ?? false) 'marca': marca!.trim(),
          if (modelo?.trim().isNotEmpty ?? false) 'modelo': modelo!.trim(),
          if (anio?.trim().isNotEmpty ?? false) 'anio': anio!.trim(),
          if (precioMin?.trim().isNotEmpty ?? false)
            'precioMin': precioMin!.trim(),
          if (precioMax?.trim().isNotEmpty ?? false)
            'precioMax': precioMax!.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => CatalogoVehiculoModel.fromJson(e))
              .toList();
        }
      }

      throw Exception('Respuesta inválida del servidor');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          'Error al obtener catálogo';
      throw Exception(message);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<CatalogoVehiculoDetalleModel> getDetalle(int id) async {
    try {
      final response = await apiClient.dio.get(
        'catalogo/detalle',
        queryParameters: {'id': id},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return CatalogoVehiculoDetalleModel.fromJson(
            data['data'] ?? {},
          );
        }
      }

      throw Exception('No se pudo cargar el detalle');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          'Error al cargar detalle';
      throw Exception(message);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}