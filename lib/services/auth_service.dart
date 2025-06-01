import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../utils/token_manager.dart';

Future<Map<String, dynamic>> loginKurir(String email, String password) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/login-kurir');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      return {
        'success': true,
        'access_token': data['data']['access_token'],
        'token_type': data['data']['token_type'],
        'message': data['message'],
      };
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Terjadi kesalahan: $e'};
  }
}

Future<Map<String, dynamic>> logout() async {
  final String url = "${ApiConfig.baseUrl}/logout";
  final String? token = await TokenManager.getToken();

  if (token == null) {
    return {'status': 'error', 'message': 'Token tidak tersedia'};
  }

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await TokenManager.removeToken();
      return {'status': 'success', 'message': 'Logout berhasil'};
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': 'error',
        'message': responseData['message'] ?? 'Gagal logout',
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal terhubung ke server: $e'};
  }
}

Future<Map<String, dynamic>?> fetchUserProfile() async {
  final String url = "${ApiConfig.baseUrl}/user";
  final String? token = await TokenManager.getToken();

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('Error: status code ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception: $e');
    return null;
  }
}
