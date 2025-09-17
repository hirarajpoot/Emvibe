import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/app_config.dart';

class PaymentService {
  // Use the URL from your app_config.dart instead of hardcoding
  static const String _baseUrl = AppConfig.stripeBackendBaseUrl;

  static Future<Map<String, dynamic>?> createPaymentSheet(String email, String uid) async {
    try {
      print('🔗 Calling: $_baseUrl/createPaymentSheet');
      print('📧 Email: $email, UID: $uid');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/createPaymentSheet'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'uid': uid}),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Payment sheet data received: $data');
        return data;
      } else {
        print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create payment sheet: ${response.body}');
      }
    } catch (e) {
      print('💥 Error creating payment sheet: $e');
      return null;
    }
  }

  static Future<void> initPaymentSheet(String email, String uid) async {
    try {
      final data = await createPaymentSheet(email, uid);
      if (data == null) throw Exception('No payment data');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['paymentIntent'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          merchantDisplayName: 'EmVibe',
        ),
      );
    } catch (e) {
      print('Error initializing payment sheet: $e');
      rethrow;
    }
  }

  static Future<bool> confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      print('Stripe Error: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      print('Error confirming payment: $e');
      return false;
    }
  }
}