import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; 
import 'dart:math' as math; 

import '../../Common_Widget/top_app_bar.dart';
import '../Chatbot/ChatBotWidgets/chat_sidebar.dart';

class ActivityController extends GetxController {
  var heartRate = 130.obs;
  var totalSteps = 5500.obs;
  var kcalBurn = 505.obs;

  var moveProgress = 0.75.obs;
  var exerciseProgress = 0.60.obs;
  var stepsProgress = 0.85.obs;

  void updateActivityData({
    int? newHeartRate,
    int? newTotalSteps,
    int? newKcalBurn,
    double? newMoveProgress,
    double? newExerciseProgress,
    double? newStepsProgress,
  }) {
    if (newHeartRate != null) heartRate.value = newHeartRate;
    if (newTotalSteps != null) totalSteps.value = newTotalSteps;
    if (newKcalBurn != null) kcalBurn.value = newKcalBurn;
    if (newMoveProgress != null) moveProgress.value = newMoveProgress;
    if (newExerciseProgress != null)
      exerciseProgress.value = newExerciseProgress;
    if (newStepsProgress != null) stepsProgress.value = newStepsProgress;
  }
}

class HabitController extends GetxController {
  var selectedTab = 'Habits'.obs;

  final List<Map<String, dynamic>> habits = [
    {
      'id': '1',
      'title': 'Morning run',
      'time': '07:00 am',
      'location': 'Park',
      'duration': '45min',
      'isCompleted': false.obs,
      'icon': '🏃‍♂️',
      'iconColor': Colors.orange.shade100,
    },
    {
      'id': '2',
      'title': '1.5L of water daily',
      'time': 'All day',
      'location': 'Park',
      'duration': '',
      'isCompleted': false.obs,
      'icon': '💧',
      'iconColor': Colors.deepPurple.shade100,
    },
    {
      'id': '3',
      'title': 'Cooking mealpreps for 3 days',
      'time': '11:00 am',
      'location': 'Home',
      'duration': '2h',
      'isCompleted': false.obs,
      'icon': '👨‍🍳',
      'iconColor': Colors.black87,
    },
  ];

  void toggleHabitCompletion(String id) {
    final habit = habits.firstWhere((h) => h['id'] == id);
    if (habit != null) {
      habit['isCompleted'].toggle();
    }
  }

  void setSelectedTab(String tab) {
    selectedTab.value = tab;
  }
}

class DailyProgressController extends GetxController {
  var dailyProgressPercentage = 85.obs; 
  var message = "Keep working on your nutrition\nand sleep".obs;

  void updateDailyProgress(int newPercentage, String newMessage) {
    dailyProgressPercentage.value = newPercentage;
    message.value = newMessage;
  }
}

class MeditationController extends GetxController {
  var title = "Meditation".obs;
  var subtitle = "Good vibes, good life".obs;
  var details = "positive thinking | 27min".obs;
  var iconEmoji = "🧘‍♀️".obs; 
  var iconBackgroundColor =
      Colors.deepPurple.shade200.obs; 

  void updateMeditationDetails({
    String? newTitle,
    String? newSubtitle,
    String? newDetails,
    String? newIconEmoji,
    Color? newIconBackgroundColor,
  }) {
    if (newTitle != null) title.value = newTitle;
    if (newSubtitle != null) subtitle.value = newSubtitle;
    if (newDetails != null) details.value = newDetails;
    if (newIconEmoji != null) iconEmoji.value = newIconEmoji;
    if (newIconBackgroundColor != null)
      iconBackgroundColor.value = newIconBackgroundColor;
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityController activityController = Get.put(ActivityController());
    final HabitController habitController = Get.put(HabitController());
    final DailyProgressController dailyProgressController = Get.put(
      DailyProgressController(),
    );
    final MeditationController meditationController = Get.put(
      MeditationController(),
    );

    return Scaffold(
      drawer: const ChatSidebar(),
      appBar: const TopAppBar(),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Calories",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                           
                            SizedBox(width: 4.w),
                            Text(
                              "Month",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down, 
                              size: 20.w,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    SizedBox(
                      height: 150.h, 
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildChartBar(0.6), 
                                _buildChartBar(0.4), 
                                _buildChartBar(0.7), 
                                _buildChartBar(0.5), 
                                _buildChartBar(0.3), 
                                _buildChartBar(0.65), 
                                _buildChartBar(0.7), 
                                _buildChartBar(
                                  0.55,
                                ), 
                                _buildChartBar(
                                  0.9,
                                  isHighlighted: true,
                                ), 
                                _buildChartBar(0.45), 
                                _buildChartBar(0.3), 
                                _buildChartBar(0.6), 
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ), 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMonthLabel("Jan"),
                              _buildMonthLabel("Feb"),
                              _buildMonthLabel("Mar"),
                              _buildMonthLabel("Apr"),
                              _buildMonthLabel("May"),
                              _buildMonthLabel("Jun"),
                              _buildMonthLabel("Jul"),
                              _buildMonthLabel("Aug"),
                              _buildMonthLabel(
                                "Sep",
                              ), 
                              _buildMonthLabel("Oct"),
                              _buildMonthLabel("Nov"),
                              _buildMonthLabel("Dec"),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ), 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:
                                [
                                      _buildValueLabel("0"),
                                      _buildValueLabel("500"),
                                      _buildValueLabel("1000"),
                                      _buildValueLabel("1500"),
                                      _buildValueLabel("2000"),
                                    ]
                                    .expand(
                                      (widget) => [
                                        widget,
                                        Spacer(), 
                                      ],
                                    )
                                    .toList()
                                  ..removeLast(), 
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Activity",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Week",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down, 
                              size: 20.w,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActivityStat(
                            icon: Icons.favorite_border,
                            iconColor: Colors.deepPurple.shade200,
                            value: "${activityController.heartRate.value}",
                            unit: "bpm",
                            valueColor: Colors.black,
                            label: "Heart rate",
                          ),
                          _buildActivityStat(
                            icon: Icons.show_chart,
                            iconColor: Colors.black,
                            value: "${activityController.totalSteps.value}",
                            unit: "", 
                            valueColor: Colors.black,
                            label: "Total steps",
                          ),
                          _buildActivityStat(
                            icon: Icons.flash_on,
                            iconColor: Colors.yellow.shade200,
                            value: "${activityController.kcalBurn.value}",
                            unit: "kCal",
                            valueColor: Colors.black,
                            label: "Kcal burn",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h), 
                    Obx(
                      () => Column(
                        children: [
                          _buildProgressBar(
                            label: "Move",
                            progress: activityController.moveProgress.value,
                            color: Colors.deepPurple.shade300,
                          ),
                          SizedBox(height: 15.h),
                          _buildProgressBar(
                            label: "Exercise",
                            progress: activityController.exerciseProgress.value,
                            color: Colors.amber.shade400,
                          ),
                          SizedBox(height: 15.h),
                          _buildProgressBar(
                            label: "Steps",
                            progress: activityController.stepsProgress.value,
                            color: Colors.blueGrey.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h), 
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Habit tracker",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Obx(
                          () => Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    habitController.setSelectedTab('Habits'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            habitController.selectedTab.value ==
                                                'Habits'
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2.w,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Habits",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color:
                                          habitController.selectedTab.value ==
                                              'Habits'
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight:
                                          habitController.selectedTab.value ==
                                              'Habits'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () =>
                                    habitController.setSelectedTab('Tasks'),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            habitController.selectedTab.value ==
                                                'Tasks'
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2.w,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Tasks",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color:
                                          habitController.selectedTab.value ==
                                              'Tasks'
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                      fontWeight:
                                          habitController.selectedTab.value ==
                                              'Tasks'
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    Obx(
                      () => Column(
                        children: habitController.habits.map((habit) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: _buildHabitItem(
                              habit['id'],
                              habit['icon'],
                              habit['iconColor'],
                              habit['title'],
                              habit['time'],
                              habit['location'],
                              habit['duration'],
                              habit['isCompleted'].value, 
                              habitController
                                  .toggleHabitCompletion, 
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h), 
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Text(
                        "Daily progress",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: 120.w, 
                        height: 120.h,
                        child: CustomPaint(
                          painter: _CircularProgressPainter(
                            progress:
                                dailyProgressController
                                    .dailyProgressPercentage
                                    .value /
                                100, 
                            color: Colors.deepPurple.shade300,
                            backgroundColor: Colors.grey.shade200,
                            strokeWidth: 10.w,
                          ),
                          child: Center(
                            child: Text(
                              "${dailyProgressController.dailyProgressPercentage.value}%",
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        dailyProgressController.message.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h), 
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors
                      .deepPurple
                      .shade50, 
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  meditationController.title.value,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  size: 24.w,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              meditationController.subtitle.value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              meditationController.details.value,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: meditationController.iconBackgroundColor.value,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            meditationController.iconEmoji.value,
                            style: TextStyle(fontSize: 40.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(double heightFactor, {bool isHighlighted = false}) {
    return Container(
      width: 16.w,
      height: 100.h * heightFactor,
      decoration: BoxDecoration(
        color: isHighlighted
            ? Colors.deepPurple.shade200
            : Colors.amber.shade200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.w),
          topRight: Radius.circular(4.w),
        ),
      ),
      child: isHighlighted
          ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 5.h),
                width: 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMonthLabel(String month, {bool isHighlighted = false}) {
    return Text(
      month,
      style: TextStyle(
        fontSize: 12.sp,
        color: isHighlighted ? Colors.deepPurple.shade600 : Colors.black87,
        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  // Helper function for Calories value labels
  Widget _buildValueLabel(String value) {
    return Text(
      value,
      style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
    );
  }

  // Helper function for Activity stats
  Widget _buildActivityStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    String unit = "",
    required Color valueColor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 28.w),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            if (unit.isNotEmpty)
              Text(
                " $unit",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
          ],
        ),
      ],
    );
  }

  // Helper function for Activity progress bars
  Widget _buildProgressBar({
    required String label,
    required double progress, // 0.0 to 1.0
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.w),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * progress,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Helper function for building a single Habit item
  Widget _buildHabitItem(
    String id,
    String iconEmoji,
    Color iconBackgroundColor,
    String title,
    String time,
    String location,
    String duration,
    bool isCompleted,
    Function(String) onToggleCompletion,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon Circle
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Center(
            child: Text(iconEmoji, style: TextStyle(fontSize: 28.sp)),
          ),
        ),
        SizedBox(width: 12.w),

        // Habit Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              SizedBox(height: 4.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  if (time.isNotEmpty)
                    _buildHabitInfoChip(Icons.access_time, time),
                  if (location.isNotEmpty)
                    _buildHabitInfoChip(Icons.location_on_outlined, location),
                  if (duration.isNotEmpty)
                    _buildHabitInfoChip(Icons.alarm, duration),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),

        // Checkbox
        GestureDetector(
          onTap: () => onToggleCompletion(id),
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.deepPurple.shade300 : Colors.white,
              borderRadius: BorderRadius.circular(6.w),
              border: Border.all(
                color: isCompleted
                    ? Colors.deepPurple.shade300
                    : Colors.grey.shade400,
                width: 1.w,
              ),
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 18.w)
                : null,
          ),
        ),
      ],
    );
  }

  // Helper function for building habit info chips
  Widget _buildHabitInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.w, color: Colors.grey.shade600),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// Custom Painter for Circular Progress
class _CircularProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arcAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      arcAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _CircularProgressPainter) {
      return oldDelegate.progress != progress ||
          oldDelegate.color != color ||
          oldDelegate.backgroundColor != backgroundColor ||
          oldDelegate.strokeWidth != strokeWidth;
    }
    return true;
  }
}
