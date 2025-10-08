// services/user_service.dart

import 'dart:convert';

import 'package:hibernadero/models/perfil.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  
  UserService({required this.baseUrl});

  // Obtener perfil del usuario
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Error al cargar el perfil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar datos personales
  Future<bool> updateUserProfile(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  // Cambiar contraseña
  Future<bool> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña actual incorrecta');
      } else {
        throw Exception('Error al cambiar contraseña');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Actualizar email
  Future<bool> updateEmail(String userId, String newEmail) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$userId/email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': newEmail}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al actualizar email: $e');
    }
  }
}