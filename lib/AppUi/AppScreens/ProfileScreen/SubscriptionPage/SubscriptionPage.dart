import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../Controllers/GeneralSettingsController.dart';
import '../../../Controllers/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<GeneralSettingsController>();
    final subController = Get.find<SubscriptionController>();

    return Obx(() {
      final isDark = settingsController.isDarkMode.value;
      final backgroundColor = isDark ? Colors.black : Colors.grey.shade100;
      final textColor = isDark ? Colors.white : Colors.black;
      final cardColor = isDark ? Colors.grey.shade900 : Colors.white;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            "Subscriptions".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          backgroundColor: backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Current Plan", textColor),
              _buildPlanCard(
                subController,
                cardColor,
                textColor,
                isDark,
              ),
              SizedBox(height: 20.h),
              _buildSectionHeader("Usage", textColor),
              _buildUsageCard(
                subController,
                cardColor,
                textColor,
                isDark,
              ),
              SizedBox(height: 20.h),
              _buildActionButtons(
                subController,
                cardColor,
                textColor,
              ),
              SizedBox(height: 20.h),
              // Dummy content to demonstrate usage
              _buildDummyUsageSection(subController, textColor, cardColor, isDark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: textColor.withOpacity(0.7),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      SubscriptionController subController, Color cardColor, Color textColor, bool isDark) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        leading: Icon(
          subController.isPremium.value ? Icons.workspace_premium : Icons.free_cancellation,
          color: subController.isPremium.value ? Colors.amber : (isDark ? Colors.white70 : Colors.black54),
          size: 30.w,
        ),
        title: Text(
          subController.isPremium.value ? "Premium Plan" : "Free Plan",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subController.isPremium.value ? "Unlimited usage" : "50 API calls/month",
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildUsageCard(
      SubscriptionController subController, Color cardColor, Color textColor, bool isDark) {
    final double percent = subController.usageLimit.value > 0 ? subController.apiCallsUsed.value / subController.usageLimit.value : 0;
    final Color progressColor = percent > 0.8 ? Colors.red : Colors.blue;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "API Calls Used",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            // Corrected: Wrapped the indicator in an Expanded widget within a Row
            Row(
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    lineHeight: 14.h,
                    percent: percent.clamp(0.0, 1.0), // Clamp the value to prevent overflow
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    progressColor: progressColor,
                    barRadius: Radius.circular(10.r),
                    padding: EdgeInsets.zero, // Remove internal padding
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "${subController.apiCallsUsed.value} of ${subController.usageLimit.value} used",
              style: TextStyle(
                fontSize: 12.sp,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      SubscriptionController subController, Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!subController.isPremium.value)
              ElevatedButton(
                onPressed: subController.upgradeToPremium,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  "Upgrade to Premium",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            if (subController.isPremium.value)
              OutlinedButton(
                onPressed: subController.downgradeToFree,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  "Downgrade to Free",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Dummy section to show live usage
  Widget _buildDummyUsageSection(SubscriptionController subController, Color textColor, Color cardColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Test Usage", textColor),
        Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  "You can tap the button below to simulate an API call.",
                  style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: subController.useApiCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  ),
                  child: Text(
                    "Simulate API Call",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}