import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/vehiculo_detalle_model.dart';
import '../models/vehiculo_model.dart';

class VehiculosService {
  final ApiClient apiClient = ApiClient();

  Future<List<VehiculoModel>> getVehiculos({
    String? marca,
    String? modelo,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.dio.get(
        'vehiculos',
        queryParameters: {
          'marca': marca,
          'modelo': modelo,
          'page': page,
          'limit': limit,
        },
      );

      final List data = response.data['data'];
      return data.map((e) => VehiculoModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al cargar vehículos'));
    } catch (e) {
      throw Exception('Error al cargar vehículos');
    }
  }

  Future<VehiculoModel> crearVehiculo({
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required int anio,
    required int cantidadRuedas,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'vehiculos',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'placa': placa,
            'chasis': chasis,
            'marca': marca,
            'modelo': modelo,
            'anio': anio,
            'cantidadRuedas': cantidadRuedas,
          }),
        }),
      );

      return VehiculoModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al crear vehículo'));
    } catch (e) {
      throw Exception('Error al crear vehículo');
    }
  }

  Future<VehiculoDetalleModel> getVehiculoDetalle(int id) async {
    try {
      final response = await apiClient.dio.get(
        'vehiculos/detalle',
        queryParameters: {'id': id},
      );

      return VehiculoDetalleModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al cargar detalle del vehículo'));
    } catch (e) {
      throw Exception('Error al cargar detalle del vehículo');
    }
  }

  Future<VehiculoModel> editarVehiculo({
    required int id,
    String? placa,
    String? chasis,
    String? marca,
    String? modelo,
    int? anio,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'id': id,
      };

      if (placa != null && placa.isNotEmpty) body['placa'] = placa;
      if (chasis != null && chasis.isNotEmpty) body['chasis'] = chasis;
      if (marca != null && marca.isNotEmpty) body['marca'] = marca;
      if (modelo != null && modelo.isNotEmpty) body['modelo'] = modelo;
      if (anio != null) body['anio'] = anio;

      final response = await apiClient.dio.post(
        'vehiculos/editar',
        data: {
          'datax': jsonEncode(body),
        },
      );

      return VehiculoModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al editar vehículo'));
    } catch (e) {
      throw Exception('Error al editar vehículo');
    }
  }

  Future<String> subirFotoVehiculo({
    required int vehiculoId,
    required File imageFile,
  }) async {
    try {
      final fileName = imageFile.path.split('/').last;

      final response = await apiClient.dio.post(
        'vehiculos/foto',
        data: FormData.fromMap({
          'datax': jsonEncode({
            'id': vehiculoId,
          }),
          'foto': await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          ),
        }),
      );

      final data = response.data['data'];
      return data['fotoUrl']?.toString() ?? '';
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al subir foto del vehículo'));
    } catch (e) {
      throw Exception('Error al subir foto del vehículo');
    }
  }

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? fallback;
    }
    return fallback;
  }
}