import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../Controllers/subscription_controller.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController subController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Emvibe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            Text(
              'Get more access with advanced intelligence and agents.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            _buildFeaturesCard(),
            SizedBox(height: 16.h),
            _buildPriceCard(),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () async {
                await subController.upgradeToPremium();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                'Upgrade to Premium',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final List<String> features = [
      'Advanced reasoning',
      'More messages and uploads',
      'Voice and vision capabilities',
      'Priority access to new models',
      'Longer context for chats',
      'Premium support',
    ];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What you get', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(height: 10.h),
            ...features.map((f) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8.w),
                      Expanded(child: Text(f)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.amber),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Premium Monthly'),
                  Text('USD 9.99 / month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Google Play Billing flow removed in favor of Stripe
}


