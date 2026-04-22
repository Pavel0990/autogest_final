import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<String> registrarUsuario(String matricula) async {
    try {
      final response = await apiClient.dio.post(
        'auth/registro',
        data: {
          'datax': jsonEncode({
            'matricula': matricula,
          }),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: const {
            'Accept': 'application/json',
          },
          validateStatus: (_) => true,
        ),
      );

      final body = response.data;
      final status = response.statusCode ?? 0;

      if (status == 201 &&
          body is Map<String, dynamic> &&
          body['success'] == true) {
        final data = body['data'];
        final token = data['token']?.toString() ?? '';

        if (token.isEmpty) {
          throw Exception('No se recibió token temporal');
        }

        return token;
      }

      if (body is Map<String, dynamic>) {
        final backendMessage =
            body['message']?.toString() ?? 'Error al registrar usuario';
        throw Exception('[$status] $backendMessage');
      }

      throw Exception('[$status] Error al registrar usuario');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error al registrar usuario');
    }
  }

  Future<AuthResponseModel> activarCuenta({
    required String tokenTemporal,
    required String contrasena,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'auth/activar',
        data: {
          'datax': jsonEncode({
            'token': tokenTemporal,
            'contrasena': contrasena,
          }),
        },
        options: _formOptions(),
      );

      final data = response.data['data'];
      final auth = AuthResponseModel.fromJson(data);

      await guardarSesion(
        token: auth.token ?? '',
        refreshToken: auth.refreshToken ?? '',
      );

      return auth;
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al activar cuenta'));
    } catch (e) {
      throw Exception('Error al activar cuenta');
    }
  }

  Future<AuthResponseModel> login({
    required String matricula,
    required String contrasena,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'auth/login',
        data: {
          'datax': jsonEncode({
            'matricula': matricula,
            'contrasena': contrasena,
          }),
        },
        options: _formOptions(),
      );

      final data = response.data['data'];
      final auth = AuthResponseModel.fromJson(data);

      await guardarSesion(
        token: auth.token ?? '',
        refreshToken: auth.refreshToken ?? '',
      );

      return auth;
    } on DioException catch (e) {
      throw Exception(
        _extractMessage(
          e,
          'Credenciales incorrectas o cuenta no activada',
        ),
      );
    } catch (e) {
      throw Exception('Credenciales incorrectas o cuenta no activada');
    }
  }

  Future<void> olvidarContrasena(String matricula) async {
    try {
      await apiClient.dio.post(
        'auth/olvidar',
        data: {
          'datax': jsonEncode({
            'matricula': matricula,
          }),
        },
        options: _formOptions(),
      );
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al recuperar contraseña'));
    } catch (e) {
      throw Exception('Error al recuperar contraseña');
    }
  }

  Future<void> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentRefreshToken = prefs.getString('refreshToken') ?? '';

      final response = await apiClient.dio.post(
        'auth/refresh',
        data: {
          'datax': jsonEncode({
            'refreshToken': currentRefreshToken,
          }),
        },
        options: _formOptions(),
      );

      final data = response.data['data'];

      await guardarSesion(
        token: data['token'] ?? '',
        refreshToken: data['refreshToken'] ?? '',
      );
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, 'Error al refrescar token'));
    } catch (e) {
      throw Exception('Error al refrescar token');
    }
  }

  Future<void> guardarSesion({
    required String token,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> obtenerRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<bool> isLoggedIn() async {
    final token = await obtenerToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
  }

  Options _formOptions() {
    return Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: const {
        'Accept': 'application/json',
      },
    );
  }

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? fallback;
    }
    return fallback;
  }
}