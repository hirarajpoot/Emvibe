import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

class ManageServerLoadController extends GetxController {
  final cpuUsage = 0.0.obs;
  final ramUsage = 0.0.obs;
  final apiCallRate = 0.0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // 🔹 Simulate server data updates every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      updateMetrics();
    });
  }

  // 🔹 Simulate server data
  void updateMetrics() {
    // 💡 In a real app, you would fetch this data from your server's API
    final random = Random();
    cpuUsage.value = (random.nextDouble() * 100).toPrecision(2);
    ramUsage.value = (random.nextDouble() * 100).toPrecision(2);
    apiCallRate.value = (random.nextDouble() * 50 + 10).toPrecision(2);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}