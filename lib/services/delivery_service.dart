import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/delivery.dart';

class DeliveryService {
  static const String baseUrl = 'http://127.0.0.1:7249/api/api';

  Future<List<Delivery>> getDeliveries() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Delivery.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch deliveries');
  }

  Future<void> createDelivery(Delivery delivery) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(delivery.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create delivery');
    }
  }

  Future<void> updateDelivery(String id, Delivery delivery) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(delivery.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update delivery');
    }
  }

  Future<void> deleteDelivery(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete delivery');
    }
  }
}
