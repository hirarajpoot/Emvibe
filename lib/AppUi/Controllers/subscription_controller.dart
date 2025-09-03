import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

class SubscriptionController extends GetxController {
  final _box = GetStorage();

  final RxBool isPremium = false.obs;
  final RxInt apiCallsUsed = 0.obs;
  final RxInt usageLimit = 50.obs; // Free plan limit

  @override
  void onInit() {
    super.onInit();
    // Load saved subscription status on app start
    _loadSubscriptionStatus();
    // A dummy function to simulate API call usage
    // This could be called from ChatBotController
    getUsageLimit();
    log("SubscriptionController initialized. Premium: ${isPremium.value}, Usage Limit: ${usageLimit.value}");
  }

  void _loadSubscriptionStatus() {
    isPremium.value = _box.read('isPremium') ?? false;
    apiCallsUsed.value = _box.read('apiCallsUsed') ?? 0;
    // Set the correct usage limit based on loaded status
    usageLimit.value = isPremium.value ? 500 : 50;
  }

  Future<void> checkSubscription() async {
    // This function would typically fetch the real subscription status from a backend.
    // We will use our local state for this example.
    isPremium.value = _box.read('isPremium') ?? false;
    getUsageLimit(); // Update the limit based on the fetched status
    log("Subscription checked. Current status: ${isPremium.value}");
  }

  Future<void> upgradeToPremium() async {
    // Simulate a successful upgrade process (e.g., after payment)
    isPremium.value = true;
    usageLimit.value = 500; // New limit for premium users
    _box.write('isPremium', true);
    Get.snackbar(
      "Success!",
      "You have been upgraded to Premium.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.contentTextStyle!.color,
    );
    log("User upgraded to Premium.");
  }

  Future<void> downgradeToFree() async {
    // Simulate a successful downgrade process
    isPremium.value = false;
    usageLimit.value = 50; // New limit for free users
    _box.write('isPremium', false);
    Get.snackbar(
      "Success!",
      "You have been downgraded to Free.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.contentTextStyle!.color,
    );
    log("User downgraded to Free.");
  }
  
  int getUsageLimit() {
    // This getter returns the current limit based on the plan
    return usageLimit.value;
  }

  void useApiCall() {
    // This function would be called by your ChatBotController
    // after each API request is made.
    if (apiCallsUsed.value < usageLimit.value) {
      apiCallsUsed.value++;
      _box.write('apiCallsUsed', apiCallsUsed.value);
    } else {
      // Handle case where limit is exceeded
      log("Usage limit exceeded!");
    }
  }
}