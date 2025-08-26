import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController? controller;
  final Color borderColor;
  final Color textColor;
  final Function(String)? onSubmitted; 
  final Widget? suffixIcon; 

  const ChatInputField({
    super.key,
    this.controller,
    required this.borderColor,
    required this.textColor,
    this.onSubmitted, 
    this.suffixIcon, 
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
        hintText: "Type a message...", 
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13.sp,
        ),
        // 🔥 contentPadding ko adjust kiya taake text theek se dikhe
        // Suffix icon ab Stack aur Align se control hoga
        contentPadding: EdgeInsets.fromLTRB(12.w, 10.h, 48.w, 10.h), // 🔥 Right padding badha di mic ke liye
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor, width: 1.5.w),
        ),
        // 🔥 Suffix icon ko Stack aur Align mein wrap kiya taake woh bottom par fixed rahe
        suffixIcon: SizedBox(
          width: 42.w, // 🔥 Icon ki width ke mutabiq SizedBox width
          height: double.infinity, // 🔥 Available height le
          child: Align(
            alignment: Alignment.bottomRight, // 🔥 Bottom right par align kiya
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h, right: 2.w), // 🔥 Thodi bottom/right padding
              child: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
