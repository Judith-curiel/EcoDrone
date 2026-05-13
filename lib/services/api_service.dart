import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://ecodroneai-backend-production.up.railway.app';

  // Método para login
  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept':
                  'application/json', // Agregado para mejor compatibilidad
            },
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 15),
          ); // Timeout para que no se quede cargando infinito

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Verificamos que el token exista en la respuesta antes de guardarlo
        // Soportamos tanto 'token' como 'access_token' (común en FastAPI)
        if (data.containsKey('token')) {
          await prefs.setString('token', data['token']);
        } else if (data.containsKey('access_token')) {
          await prefs.setString('token', data['access_token']);
        }
        return data;
      } else {
        // Intentamos capturar el error del backend (soporta 'message' o 'detail' común en FastAPI)
        String errorMessage = 'Error ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] ?? errorData['detail'] ?? errorMessage;
        } catch (_) {
          // Si no es JSON, mostramos el cuerpo de la respuesta si no es muy largo
          errorMessage = response.body.length < 100
              ? response.body
              : 'Error inesperado del servidor';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para registro
  static Future<Map<String, dynamic>?> register(
    String nombre,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/usuarios');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nombre': nombre,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        String errorMessage = 'Error en registro (${response.statusCode})';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] ?? errorData['detail'] ?? errorMessage;
        } catch (_) {
          errorMessage = response.body;
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      final url = Uri.parse('$baseUrl/auth/logout');
      try {
        await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } catch (
        _
      ) {} // Ignoramos si falla el logout en red, igual borramos local
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
