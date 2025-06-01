import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipping_model.dart';
import '../services/api_config.dart';
import '../utils/token_manager.dart';
import '../models/shipping_detail_model.dart';

Future<List<Order>> fetchPendingOrders() async {
  final token = await TokenManager.getToken();

  if (token == null) {
    print('[PENDING ORDER] ❌ Token tidak ditemukan');
    throw Exception('Token tidak ditemukan, user belum login');
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/shipping-pending');

  print('[PENDING ORDER] 🔁 MEMULAI REQUEST');
  print('URL    : $url');
  print('HEADER : Authorization: Bearer $token');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print('[PENDING ORDER] STATUS CODE: ${response.statusCode}');
  print('[PENDING ORDER] RESPONSE BODY: ${response.body}');

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    if (body['status'] == 'success') {
      final List data = body['data'];
      print('[PENDING ORDER] ✅ Jumlah Data: ${data.length}');
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      print('[PENDING ORDER] ⚠️ API status != success: ${body['message']}');
      throw Exception('API error: ${body['message']}');
    }
  } else if (response.statusCode == 401) {
    print('[PENDING ORDER] ❌ Token tidak valid / expired');
    throw Exception('Unauthenticated: Sesi Anda telah habis, silakan login kembali.');
  } else {
    print('[PENDING ORDER] ❌ Gagal memuat data: ${response.statusCode}');
    throw Exception('Gagal memuat data: ${response.statusCode}');
  }
}


Future<ShippingDetailModel> fetchShippingDetail(int transactionId) async {
  final token = await TokenManager.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/shipping/$transactionId');

  print('[FETCH SHIPPING DETAIL]');
  print('URL    : $url');
  print('HEADER : Authorization: Bearer $token');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ShippingDetailModel.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat detail pengiriman: ${response.statusCode}');
    }
  } catch (e) {
    print('ERROR FETCH SHIPPING DETAIL: $e');
    rethrow;
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

Future<void> markShippingAsDone(String transactionCode) async {
  final token = await TokenManager.getToken();
  if (token == null) {
    throw Exception('Token tidak ditemukan, user belum login');
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/shipping-done');

  final response = await http.patch(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'transaction_code': transactionCode}),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['status'] != 'success') {
      throw Exception('Gagal mengubah status: ${responseData['message']}');
    }
  } else {
    throw Exception('Request gagal dengan status: ${response.statusCode}');
  }
}
