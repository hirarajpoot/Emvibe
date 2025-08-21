import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Builder(
              builder: (context) => IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                icon: Icon(Icons.menu, color: Colors.white, size: 22.w),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            children: [
              Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(6.w),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "Miley",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade50,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              icon: Icon(Icons.search, color: Colors.black54, size: 22.w),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow.shade100,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              icon: Icon(Icons.settings, color: Colors.black54, size: 22.w),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 4.w),
          Stack(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  icon: Icon(Icons.notifications,
                      color: Colors.white, size: 22.w),
                  onPressed: () {},
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  constraints:
                      BoxConstraints(minWidth: 12.w, minHeight: 12.w),
                  child: Text('2',
                      style:
                          TextStyle(color: Colors.white, fontSize: 8.sp)),
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text("M",
                style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          ),
        ],
      ),
    );
  }
}