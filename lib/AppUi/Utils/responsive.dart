import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static bool isMobile() => 1.sw < 600; 
  static bool isTablet() => 1.sw >= 600 && 1.sw < 1024;
  static bool isDesktop() => 1.sw >= 1024;

  static double scale({double base = 1}) {
    final w = 1.sw;
    if (w >= 1200) return base * 1.2;
    if (w >= 800) return base * 1.1;
    return base;
  }

  static double font(double size) => size.sp; 

  static double h(double height) => height.h;
  static double w(double width) => width.w;
}
