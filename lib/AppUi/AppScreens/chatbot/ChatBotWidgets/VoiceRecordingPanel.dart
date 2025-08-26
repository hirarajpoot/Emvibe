import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import '../../../Controllers/chatbot_controller.dart';

// 🔥 Naya Sound Wave Visualizer Widget
class _SoundWaveVisualizer extends StatefulWidget {
  const _SoundWaveVisualizer({super.key});

  @override
  _SoundWaveVisualizerState createState() => _SoundWaveVisualizerState();
}

class _SoundWaveVisualizerState extends State<_SoundWaveVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = List.generate(10, (index) => 0.0); // 10 bars for the visualizer

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), 
    )..repeat(reverse: true);

    _controller.addListener(() {
      setState(() {
        // Randomly adjust bar heights for a dynamic wave effect
        for (int i = 0; i < _barHeights.length; i++) {
          _barHeights[i] = (Random().nextDouble() * 0.8 + 0.2) * 1.0; // Between 20% and 100% of max height
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 SizedBox width hata diya, ab yeh parent ke Expanded ke mutabiq adjust hoga
    return CustomPaint(
      painter: _SoundWavePainter(
        _barHeights.map((e) => e * 30.w).toList(), // Scale heights to actual pixels
        _controller.value, 
      ),
    );
  }
}

class _SoundWavePainter extends CustomPainter {
  final List<double> barHeights;
  final double animationValue;

  _SoundWavePainter(this.barHeights, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade600 
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round; 

    // 🔥 Bar width aur spacing ko total available width ke hisaab se adjust kiya
    final double totalBarsWidth = size.width;
    final double barCount = barHeights.length.toDouble();
    final double spacingFactor = 0.3; // Bars ke beech ki spacing ka factor
    
    final double barWidth = totalBarsWidth / (barCount + (barCount - 1) * spacingFactor);
    final double spacing = barWidth * spacingFactor;

    for (int i = 0; i < barHeights.length; i++) {
      final double x = (i * (barWidth + spacing));
      final double currentBarHeight = barHeights[i];
      final double startY = (size.height - currentBarHeight) / 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, startY, barWidth, currentBarHeight),
          Radius.circular(barWidth / 2), 
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoundWavePainter oldDelegate) {
    return oldDelegate.barHeights != barHeights || oldDelegate.animationValue != animationValue;
  }
}


// 🔥 Existing VoiceRecordingPanel
class VoiceRecordingPanel extends StatelessWidget {
  const VoiceRecordingPanel({super.key});

  String _formatDuration(int milliseconds) {
    int seconds = (milliseconds / 1000).round();
    String minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    String remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatBotController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      child: Row(
        // 🔥 Layout ko adjust kiya
        children: [
          // Delete button
          InkWell(
            onTap: c.cancelVoiceRecord,
            borderRadius: BorderRadius.circular(21.w),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 243, 242, 242),
              ),
              child: Icon(Icons.delete_outline, color: Colors.black, size: 22.w),
            ),
          ),
          SizedBox(width: 8.w), // 🔥 Delete icon aur timer ke beech space

          // 🔥 Timer (duration) icon ke saath
          Obx(
            () => Text(
              _formatDuration(c.recordDurationMs.value), 
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 12.w), // 🔥 Timer aur waves ke beech space

          // 🔥 Waves ko Expanded mein rakha taake woh zyada jagah le
          Expanded(
            child: SizedBox(
              height: 30.w, // Fixed height for the waves visualizer
              child: const _SoundWaveVisualizer(), 
            ),
          ),
          SizedBox(width: 12.w), // 🔥 Waves aur send button ke beech space

          // Send button
          InkWell(
            onTap: () => c.stopVoiceRecord(send: true),
            borderRadius: BorderRadius.circular(21.w),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade600,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 22.w),
            ),
          ),
        ],
      ),
    );
  }
}
