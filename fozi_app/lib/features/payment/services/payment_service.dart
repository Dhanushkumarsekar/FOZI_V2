import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  // static const String baseUrl = 'http://localhost:5000/api';
    static const String baseUrl = "http://10.112.254.203:5000/api"; // --> Boopesh
  static final Razorpay _razorpay = Razorpay();

  static Future<void> startPayment({
    required int amount,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create order');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final options = {
      'key': 'rzp_test_YOUR_KEY',
      'amount': data['amount'],
      'order_id': data['id'],
      'name': 'FOZI Store',
      'description': 'Perfume Purchase',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@fozi.com',
      },
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.open(options);
  }

  static Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/payment/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
        'userId': 'user123',
        'items': <Map<String, dynamic>>[],
        'totalAmount': 5000,
      }),
    );
  }
}
