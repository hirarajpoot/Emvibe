import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class PaymentService {
  /// Create PaymentSheet session from backend and open Stripe PaymentSheet
  static Future<void> initPaymentSheet(
    BuildContext context,
    String email,
  ) async {
    try {
      // 1️⃣ Call backend
      final url = Uri.parse(
        '${AppConfig.stripeBackendBaseUrl}/stripe/create-payment-sheet',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create PaymentSheet: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final clientSecret = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customerId = data['customer'];

      // 2️⃣ Initialize PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          merchantDisplayName: 'EmVibe',
          style: ThemeMode.system, // automatic light/dark mode
          allowsDelayedPaymentMethods: true,
        ),
      );

      // 3️⃣ Present PaymentSheet to user
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Payment successful!")));
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Payment cancelled: ${e.error.localizedMessage}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Error: $e")));
    }
  }
}
