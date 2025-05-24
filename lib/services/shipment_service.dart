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

Future<Map<String, dynamic>> shippingAccept({required int id}) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/shipping-accept');
  final token = await TokenManager.getToken();

  final response = await http.patch(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'id': id}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Gagal mengubah status pengiriman');
  }
}

Future<List<dynamic>> getProcessingShipments() async {
  final token = await TokenManager.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/shipping-process');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      return data['data'] as List<dynamic>;
    } else {
      throw Exception(
        'Gagal memuat data: ${data['message'] ?? 'Unknown error'}',
      );
    }
  } else {
    throw Exception('Request gagal dengan status: ${response.statusCode}');
  }
}
