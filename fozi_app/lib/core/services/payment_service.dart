import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {

  /// 🔥 CHANGE THIS FOR MOBILE (IMPORTANT)
  // static const String baseUrl = "http://localhost:5000/api";
  // Example for mobile:
  // static const String baseUrl = "http://192.168.1.10:5000/api";

  static const String baseUrl = "http://10.112.254.203:5000/api"; // --> Boopesh

  static Razorpay razorpay = Razorpay();

  /// 🚀 START PAYMENT
  static Future<void> startPayment({
    required int amount,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
  }) async {

    try {

      /// 🔥 STEP 1 — CREATE ORDER FROM BACKEND
      final response = await http.post(
        Uri.parse("$baseUrl/payment/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create order");
      }

      final data = jsonDecode(response.body);

      /// 🔥 STEP 2 — RAZORPAY OPTIONS
      var options = {
        'key': 'rzp_test_xxxxx', // 🔥 PUT YOUR REAL KEY
        'amount': data['amount'],
        'order_id': data['id'],
        'name': 'FOZI Store',
        'description': 'Perfume Purchase',
        'prefill': {
          'contact': '9999999999',
          'email': 'test@gmail.com'
        }
      };

      /// 🔥 STEP 3 — LISTEN EVENTS
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) {
        onSuccess(response);
      });

      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse response) {
        onError(response);
      });

      /// 🔥 STEP 4 — OPEN PAYMENT
      razorpay.open(options);

    } catch (e) {
      print("PAYMENT ERROR: $e");
    }
  }

  /// ✅ VERIFY PAYMENT (SAVE ORDER)
  static Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required List items,
    required int totalAmount,
  }) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/payment/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
          "userId": userId,
          "items": items,
          "totalAmount": totalAmount
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Verification failed");
      }

    } catch (e) {
      print("VERIFY ERROR: $e");
    }
  }

  /// 🧹 CLEANUP
  static void dispose() {
    razorpay.clear();
  }
}