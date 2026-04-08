// Product Service
import 'dart:convert';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response = await ApiClient.get(ApiEndpoints.products);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}