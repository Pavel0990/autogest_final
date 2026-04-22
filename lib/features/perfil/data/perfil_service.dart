import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/perfil_model.dart';

class PerfilService {
  final ApiClient apiClient = ApiClient();

  Future<PerfilModel> getPerfil() async {
    try {
      final response = await apiClient.dio.get(
        'perfil',
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 200 && body is Map<String, dynamic>) {
        return PerfilModel.fromJson(body['data']);
      }

      if (body is Map<String, dynamic>) {
        throw Exception(body['message']?.toString() ?? 'Error al cargar perfil');
      }

      throw Exception('Error al cargar perfil');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw Exception(data['message']?.toString() ?? 'Error al cargar perfil');
      }

      throw Exception('Error al cargar perfil');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al cargar perfil');
    }
  }

  Future<void> subirFotoPerfil(File imageFile) async {
    try {
      final response = await apiClient.dio.post(
        'perfil/foto',
        data: FormData.fromMap({
          'foto': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
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
          body['message']?.toString() ?? 'Error al subir foto de perfil',
        );
      }

      throw Exception('Error al subir foto de perfil');
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        throw Exception(
          data['message']?.toString() ?? 'Error al subir foto de perfil',
        );
      }

      throw Exception('Error al subir foto de perfil');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al subir foto de perfil');
    }
  }
}