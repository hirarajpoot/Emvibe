// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static bool isMobile() => 1.sw < 600; // screen width
  static bool isTablet() => 1.sw >= 600 && 1.sw < 1024;
  static bool isDesktop() => 1.sw >= 1024;

  /// Scale factor using ScreenUtil width
  static double scale({double base = 1}) {
    final w = 1.sw;
    if (w >= 1200) return base * 1.2;
    if (w >= 800) return base * 1.1;
    return base;
  }

  /// Example helpers for text scaling
  static double font(double size) => size.sp; 

  /// Example helpers for spacing
  static double h(double height) => height.h;
  static double w(double width) => width.w;
}
