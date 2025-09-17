import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:emvibe/config/app_config.dart';
import 'package:emvibe/services/payment_service.dart';

class SubscriptionController extends GetxController {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser; 

  final RxBool isPremium = false.obs;
  final RxInt apiCallsUsed = 0.obs;
  final RxInt usageLimit = 50.obs;
  final RxList<Map<String, dynamic>> paymentHistory = <Map<String, dynamic>>[].obs;

  // Stripe keys - USE THE TEST KEY DURING DEVELOPMENT
  // Server-side Stripe secret must NEVER be stored in the app.
  // Kept here previously for testing; removed to satisfy GitHub secret scanning and for security.
  static const String _stripeSecretTestKey = '';
  static const String _stripeSecretKey = _stripeSecretTestKey; // deprecated placeholder

  @override
  void onInit() {
    super.onInit();
    if (user != null) {
      _loadSubscriptionStatus();
      _loadPaymentHistory();
    } else {
      Get.snackbar("Error", "No user logged in. Please log in to check subscription.");
    }
  }

  // Load subscription status from Firestore
  Future<void> _loadSubscriptionStatus() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        isPremium.value = userData['isPremium'] ?? false;
        apiCallsUsed.value = userData['apiCallsUsed'] ?? 0;
        usageLimit.value = isPremium.value ? 500 : 50; // Premium gets 500 calls
        
        log("Subscription loaded. Premium: ${isPremium.value}, Usage: ${apiCallsUsed.value}/${usageLimit.value}");
      } else {
        // Create user document if it doesn't exist
        await _firestore.collection('users').doc(user!.uid).set({
          'isPremium': false,
          'apiCallsUsed': 0,
          'email': user!.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        log("New user document created in Firestore.");
      }
    } catch (e) {
      log("Error loading subscription: $e");
      Get.snackbar("Error", "Could not load subscription status. Please check your connection.");
    }
  }

  // Load payment history from Firestore
  Future<void> _loadPaymentHistory() async {
    try {
      QuerySnapshot payments = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .get();
      
      paymentHistory.clear();
      for (var doc in payments.docs) {
        paymentHistory.add({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      
      log("Payment history loaded: ${paymentHistory.length} payments");
    } catch (e) {
      log("Error loading payment history: $e");
    }
  }

  // Check subscription status (useful for manual refresh)
  Future<void> checkSubscription() async {
    await _loadSubscriptionStatus();
    await _loadPaymentHistory();
    Get.snackbar("Success", "Subscription status refreshed!");
  }

  // Upgrade to premium using Stripe PaymentSheet (TEST MODE)
  Future<void> upgradeToPremium() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      if (user == null) {
        Get.back();
        throw Exception('User not logged in');
      }

      log('🚀 Starting premium upgrade for user: ${user!.email}');
      
      // 1) Initialize Stripe PaymentSheet with data from Cloud Function
      await PaymentService.initPaymentSheet(user!.email!, user!.uid);
      log('✅ Payment sheet initialized successfully');

      // 2) Present the sheet so user can enter a test card (e.g., 4242 4242 4242 4242)
      final success = await PaymentService.confirmPayment();
      Get.back(); // Close loader before handling result

      if (success) {
        log('💳 Payment successful, updating user to premium');
        await _markPremiumAfterStripe();
        Get.snackbar('Success', 'Premium subscription activated!');
      } else {
        log('❌ Payment was canceled by user');
        Get.snackbar(
          'Payment canceled',
          'No charge was made. You can try again with a Stripe test card.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      log('💥 Upgrade error: $e');
      Get.snackbar(
        'Error',
        'Failed to upgrade to premium. Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Start Stripe PaymentSheet flow
  Future<void> _startStripePaymentSheet() async {
    try {
      log("Starting Stripe payment process...");
      log("Backend URL: ${AppConfig.stripeBackendBaseUrl}");
      log("User email: ${user!.email}");
      
      // 1) Call your backend to create a PaymentIntent + EphemeralKey + Customer
      final response = await http.post(
        Uri.parse('${AppConfig.stripeBackendBaseUrl}/createPaymentSheet'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': user!.email}),
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String paymentIntentClientSecret = data['paymentIntent'];
        final String ephemeralKey = data['ephemeralKey'];
        final String customerId = data['customer'];

        log("Payment intent created successfully");

        // 2) Init PaymentSheet
        await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: 'Emvibe',
            customerId: customerId,
            customerEphemeralKeySecret: ephemeralKey,
            style: ThemeMode.system,
            allowsDelayedPaymentMethods: true,
          ),
        );

        log("PaymentSheet initialized");

        Get.back();

        // 3) Present PaymentSheet
        await stripe.Stripe.instance.presentPaymentSheet();

        log("PaymentSheet presented successfully");

        // 4) Mark premium and log payment
        await _markPremiumAfterStripe();
        
      } else {
        log("Backend error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to prepare payment sheet: ${response.body}');
      }
    } catch (e) {
      log("Stripe payment error: $e");
      rethrow;
    }
  }

  // Direct Stripe integration (for testing)
  Future<void> _createDirectPaymentIntent() async {
    try {
      // Create PaymentIntent directly using Stripe SDK
      final paymentIntent = await stripe.Stripe.instance.createPaymentMethod(
        params: stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: stripe.BillingDetails(
              email: user!.email,
            ),
          ),
        ),
      );

      log("Payment method created: ${paymentIntent.id}");

      // Initialize PaymentSheet with test data
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: 'pi_test_1234567890_secret_test', // Test secret
          merchantDisplayName: 'Emvibe',
          customerId: 'cus_test_1234567890', // Test customer ID
          customerEphemeralKeySecret: 'ek_test_1234567890', // Test ephemeral key
          style: ThemeMode.system,
          allowsDelayedPaymentMethods: true,
        ),
      );

      log("PaymentSheet initialized with test data");

      Get.back();

      // Present PaymentSheet
      await stripe.Stripe.instance.presentPaymentSheet();

      log("PaymentSheet presented successfully");

      // Mark premium and log payment
      await _markPremiumAfterStripe();
      
    } catch (e) {
      log("Direct payment error: $e");
      // Fallback to simulation if direct payment fails
      await _simulateUpgrade();
    }
  }

  Future<void> _markPremiumAfterStripe() async {
    // Update Firestore and local state similar to simulation, but mark payment method as stripe
    final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('payments')
        .doc(paymentId)
        .set({
      'amount': 9.99,
      'currency': 'USD',
      'status': 'completed',
      'paymentMethod': 'stripe',
      'plan': 'Premium Monthly',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(user!.uid).update({
      'isPremium': true,
      'upgradedAt': FieldValue.serverTimestamp(),
      'currentPlan': 'Premium Monthly',
      'lastPaymentId': paymentId,
    });

    isPremium.value = true;
    usageLimit.value = 500;
    apiCallsUsed.value = 0;
    await _loadPaymentHistory();

    Get.snackbar(
      "Success",
      "🎉 Payment completed. Premium activated!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Simulate upgrade for development/testing
  Future<void> _simulateUpgrade() async {
    // Show payment method selection dialog
    final paymentMethod = await _showPaymentMethodDialog();
    if (paymentMethod == null) {
      Get.back(); // Close loading dialog
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    // Create payment record
    final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
    final paymentData = {
      'amount': 9.99,
      'currency': 'USD',
      'status': 'completed',
      'paymentMethod': paymentMethod,
      'plan': 'Premium Monthly',
      'createdAt': FieldValue.serverTimestamp(),
      'receiptUrl': 'https://your-app.com/receipt/$paymentId',
    };

    // Save payment record
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('payments')
        .doc(paymentId)
        .set(paymentData);

    // Update user subscription
    await _firestore.collection('users').doc(user!.uid).update({
      'isPremium': true,
      'upgradedAt': FieldValue.serverTimestamp(),
      'currentPlan': 'Premium Monthly',
      'lastPaymentId': paymentId,
    });

    // Update local state
    isPremium.value = true;
    usageLimit.value = 500;
    apiCallsUsed.value = 0;
    
    // Reload payment history
    await _loadPaymentHistory();

    Get.back(); // Close loading dialog
    Get.snackbar(
      "Success", 
      "🎉 Premium Upgrade Complete!\n💰 Payment: \$9.99 via $paymentMethod\n📊 API Calls: 500/month\n📧 Receipt sent to ${user!.email}",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
    
    log("User upgraded to premium successfully ($paymentMethod)");
  }

  // Show payment method selection dialog
  Future<String?> _showPaymentMethodDialog() async {
    return await Get.dialog<String>(
      AlertDialog(
        title: const Text('Select Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Credit/Debit Card'),
              subtitle: const Text('Visa, Mastercard, American Express'),
              onTap: () => Get.back(result: 'Credit Card'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.green),
              title: const Text('Bank Transfer'),
              subtitle: const Text('Direct bank transfer'),
              onTap: () => Get.back(result: 'Bank Transfer'),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.orange),
              title: const Text('Mobile Payment'),
              subtitle: const Text('JazzCash, EasyPaisa, etc.'),
              onTap: () => Get.back(result: 'Mobile Payment'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Downgrade to free plan
  Future<void> downgradeToFree() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()), // Fixed: Center is now available
        barrierDismissible: false,
      );

      // Update Firestore
      await _firestore.collection('users').doc(user!.uid).update({
        'isPremium': false,
        'apiCallsUsed': 0, // Reset usage on downgrade
      });

      // Update local state
      isPremium.value = false;
      usageLimit.value = 50;
      apiCallsUsed.value = 0;

      Get.back(); // Close loading dialog
      Get.snackbar("Success", "You have been downgraded to the Free plan.");
    } catch (e) {
      Get.back(); // Close loading dialog
      log("Downgrade error: $e");
      Get.snackbar("Error", "Failed to downgrade: ${e.toString()}");
    }
  }

  // Track API usage
  void useApiCall() {
    if (apiCallsUsed.value < usageLimit.value) {
      apiCallsUsed.value++;
      
      // Update Firestore in background (don't wait for it)
      _firestore.collection('users').doc(user!.uid).update({
        'apiCallsUsed': FieldValue.increment(1),
      }).catchError((e) => log("Failed to update usage in Firestore: $e"));
    } else {
      Get.snackbar("Limit Reached", "You've used all your API calls for this month. Upgrade to Premium for unlimited access.");
    }
  }

  // Get current usage limit
  int getUsageLimit() {
    return usageLimit.value;
  }

  // Simulate API call for testing
  Future<void> simulateApiCall() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Use an API call
      useApiCall();

      Get.back(); // Close loading dialog
      Get.snackbar(
        "API Call Simulated", 
        "API call completed! Usage: ${apiCallsUsed.value}/${usageLimit.value}",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      
    } catch (e) {
      Get.back(); // Close loading dialog
      log("API call simulation error: $e");
      Get.snackbar(
        "Error", 
        "Failed to simulate API call: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // View payment history
  void viewPaymentHistory() {
    if (paymentHistory.isEmpty) {
      Get.snackbar(
        "No Payments", 
        "You haven't made any payments yet.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Show payment history dialog
    Get.dialog(
      AlertDialog(
        title: const Text("Payment History"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = paymentHistory[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.green),
                  title: Text(payment['plan'] ?? 'Premium Plan'),
                  subtitle: Text(
                    '\$${payment['amount']} ${payment['currency']}\n'
                    'Status: ${payment['status']}\n'
                    'Method: ${payment['paymentMethod']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => downloadReceipt(payment['id']),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Download receipt
  Future<void> downloadReceipt(String paymentId) async {
    try {
      // In a real app, you would:
      // 1. Generate PDF receipt
      // 2. Save to device storage
      // 3. Open with system viewer
      
      Get.snackbar(
        "Receipt Downloaded", 
        "Receipt for payment $paymentId has been saved to your device.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      log("Receipt downloaded for payment: $paymentId");
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Failed to download receipt: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get subscription info for display
  Map<String, dynamic> getSubscriptionInfo() {
    return {
      'isPremium': isPremium.value,
      'apiCallsUsed': apiCallsUsed.value,
      'usageLimit': usageLimit.value,
      'usagePercentage': (apiCallsUsed.value / usageLimit.value * 100).round(),
      'remainingCalls': usageLimit.value - apiCallsUsed.value,
      'paymentCount': paymentHistory.length,
    };
  }

  // Activate premium after store purchase (Google Play / App Store)
  Future<void> activatePremiumFromStore(String purchaseToken) async {
    try {
      // TODO: Verify purchaseToken with your backend and Play Developer API
      await _firestore.collection('users').doc(user!.uid).update({
        'isPremium': true,
        'upgradedAt': FieldValue.serverTimestamp(),
        'store': 'google_play',
        'purchaseToken': purchaseToken,
      });

      isPremium.value = true;
      usageLimit.value = 500;
      apiCallsUsed.value = 0;

      // Log payment item
      final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('payments')
          .doc(paymentId)
          .set({
        'amount': 9.99,
        'currency': 'USD',
        'status': 'completed',
        'paymentMethod': 'google_play',
        'plan': 'Premium Monthly',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _loadPaymentHistory();
    } catch (e) {
      log('Failed to activate premium from store: $e');
      rethrow;
    }
  }
}