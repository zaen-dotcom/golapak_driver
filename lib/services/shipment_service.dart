import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipping_model.dart';
import '../services/api_config.dart';
import '../utils/token_manager.dart';
import '../models/shipping_detail_model.dart';

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

Future<ShippingDetailModel> fetchShippingDetail(int transactionId) async {
  final token = await TokenManager.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/shipping/$transactionId');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return ShippingDetailModel.fromJson(data['data']);
  } else {
    throw Exception('Gagal memuat detail pengiriman: ${response.statusCode}');
  }
}
