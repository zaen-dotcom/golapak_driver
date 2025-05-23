import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../services/api_config.dart';
import '../utils/token_manager.dart';

Future<List<Order>> fetchPendingOrders() async {
  final token = await TokenManager.getToken();

  if (token == null) {
    throw Exception('Token tidak ditemukan, user belum login');
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/shipping-pending');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    if (body['status'] == 'success') {
      final List data = body['data'];
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('API error: ${body['message']}');
    }
  } else {
    throw Exception('Failed to load orders: ${response.statusCode}');
  }
}
