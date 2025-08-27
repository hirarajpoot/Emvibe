import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController? controller;
  final Color borderColor;
  final Color textColor;
  final Function(String)? onSubmitted; 
  final Widget? suffixIcon; 
  final String? hintText; // ✅ Added for translations

  const ChatInputField({
    super.key,
    this.controller,
    required this.borderColor,
    required this.textColor,
    this.onSubmitted, 
    this.suffixIcon, 
    this.hintText, // ✅ Now you can pass .tr
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1, 
      maxLines: 4, 
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 14.sp, color: textColor),
      onSubmitted: onSubmitted, 
      decoration: InputDecoration(
        isDense: true, 
        hintText: hintText ?? "Type a message...", // ✅ Uses passed translation key
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13.sp,
        ),
        contentPadding: EdgeInsets.fromLTRB(
          12.w, 
          10.h, 
          suffixIcon != null ? 48.w : 12.w, // ✅ Adjust if suffix present
          10.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor, width: 1.5.w),
        ),
        suffixIcon: suffixIcon != null
            ? SizedBox(
                width: 42.w,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.h, right: 2.w),
                    child: suffixIcon,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
