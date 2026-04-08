import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/product/models/product_model.dart';

class ApiService {
  /// 🔥 BASE URL
  // static const String baseUrl = "http://192.168.208.203:5000/api";

   static const String baseUrl = "http://10.112.254.203:5000/api"; // --> Boopesh

  /// 🔐 TOKEN
  static String? token;

  /// 🔐 HEADERS
  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  // ==============================
  // 🔐 USER LOGIN
  // ==============================
  static Future<Map?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: headers,
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data["token"] != null) {
        token = data["token"];
        return data;
      }

      return null;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }

  // ==============================
  // 🔐 ADMIN LOGIN
  // ==============================
  static Future<bool> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/admin/login"),
        headers: headers,
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data["success"] == true) {
        token = data["token"];
        return true;
      }

      return false;
    } catch (e) {
      print("ADMIN LOGIN ERROR: $e");
      return false;
    }
  }

  // ==============================
  // 📝 REGISTER
  // ==============================
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: headers,
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(res.body);

      return data["success"] == true;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }

  // ==============================
  // 🛍 GET PRODUCTS
  // ==============================
  static Future<List<Product>> getProducts() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/products"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        return data.map((e) => Product.fromJson(e)).toList();
      }

      throw Exception("Product fetch failed");
    } catch (e) {
      print("PRODUCT ERROR: $e");
      throw Exception("Product error");
    }
  }

  // ==============================
  // 🚀 ADD PRODUCT WITH IMAGE
  // ==============================
  static Future<void> addProductWithImage({
    required String name,
    required int price,
    required File imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/admin/product"),
      );

      if (token == null) {
        throw Exception("Token missing (Admin login required)");
      }

      request.headers['Authorization'] = "Bearer $token";

      request.fields['name'] = name;
      request.fields['price'] = price.toString();

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: $responseBody");

      if (response.statusCode != 200) {
        throw Exception("Upload failed");
      }

      print("✅ PRODUCT UPLOADED");
    } catch (e) {
      print("UPLOAD ERROR: $e");
      throw Exception("Upload failed");
    }
  }

  // ==============================
  // ❌ DELETE PRODUCT
  // ==============================
  static Future<void> deleteProduct(String id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/admin/product/$id"),
      headers: headers,
    );

    if (res.statusCode != 200) {
      throw Exception("Delete failed");
    }
  }

  // ==============================
  // ✏️ UPDATE PRODUCT
  // ==============================
  static Future<void> updateProduct(
      String id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/admin/product/$id"),
      headers: headers,
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception("Update failed");
    }
  }

  // ==============================
  // 🛒 ADD TO CART
  // ==============================
  static Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/cart/add"),
      headers: headers,
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
        "quantity": quantity,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Cart failed");
    }
  }

  // ==============================
  // 📦 CREATE ORDER
  // ==============================
  static Future<void> createOrder(Map orderData) async {
    final res = await http.post(
      Uri.parse("$baseUrl/orders/create"),
      headers: headers,
      body: jsonEncode(orderData),
    );

    if (res.statusCode != 200) {
      throw Exception("Order failed");
    }
  }

  // ==============================
  // 📦 USER ORDERS
  // ==============================
  static Future<List<dynamic>> getOrders(String userId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/orders/$userId"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Orders failed");
  }

  // ==============================
  // 👨‍💼 ADMIN ORDERS
  // ==============================
  static Future<List<dynamic>> getAdminOrders() async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/orders"),
      headers: headers,
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200 && data["success"]) {
      return data["orders"];
    }

    throw Exception("Admin orders failed");
  }

  // ==============================
  // 🔄 UPDATE ORDER STATUS
  // ==============================
  static Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final res = await http.put(
      Uri.parse("$baseUrl/admin/update-order"),
      headers: headers,
      body: jsonEncode({
        "orderId": orderId,
        "status": status,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Update failed");
    }
  }

  // ==============================
  // 💳 VERIFY PAYMENT
  // ==============================
  static Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required List items,
    required int totalAmount,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/payment/verify"),
      headers: headers,
      body: jsonEncode({
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
        "userId": userId,
        "items": items,
        "totalAmount": totalAmount,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Payment failed");
    }
  }

  // ==============================
  // 📍 TRACK ORDER
  // ==============================
  static Future<Map> trackOrder(String orderId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/orders/track/$orderId"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Tracking failed");
  }

  // ==============================
  // 👤 ADMIN USERS
  // ==============================
  static Future<List<dynamic>> getAdminUsers() async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/users"),
      headers: headers,
    );

    final data = jsonDecode(res.body);

    return data["users"];
  }

  // ==============================
  // 📊 ADMIN STATS
  // ==============================
  static Future<Map<String, dynamic>> getStats() async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/stats"),
      headers: headers,
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200 && data["success"]) {
      return data["stats"];
    }

    throw Exception("Stats failed");
  }
}