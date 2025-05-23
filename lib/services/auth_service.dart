import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

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
