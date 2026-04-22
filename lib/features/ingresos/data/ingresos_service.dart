import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/ingreso_model.dart';

class IngresosService {
  final ApiClient apiClient = ApiClient();

  // 🔹 Obtener lista de ingresos por vehículo
  Future<List<IngresoModel>> getIngresos(int vehiculoId) async {
    try {
      final response = await apiClient.dio.get(
        'ingresos',
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
          return rawData.map((e) => IngresoModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  // 🔹 Crear ingreso
  Future<void> crearIngreso({
    required int vehiculoId,
    required num monto,
    required String fecha,
    required String descripcion,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'ingresos',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'vehiculo_id': vehiculoId,
            'monto': monto,
            'fecha': fecha,
            'concepto': descripcion, // 🔥 FIX IMPORTANTE
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
          body['message']?.toString() ?? 'Error al registrar ingreso',
        );
      }

      throw Exception('Error al registrar ingreso');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw Exception(
          data['message']?.toString() ?? 'Error al registrar ingreso',
        );
      }

      throw Exception('Error al registrar ingreso');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al registrar ingreso');
    }
  }
}