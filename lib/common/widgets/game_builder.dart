import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildGameContainer(
  String imageLogo,
  Color? color,
  String? imageBackground,
  VoidCallback? ontap,
) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color ?? Colors.amber,
        image: imageBackground != null
            ? DecorationImage(
                image: AssetImage(imageBackground),
                fit: BoxFit.cover,
              )
            : null,
      ),
      height: 100.h,
      width: 110.w,
      child: Center(child: Image.asset(imageLogo, height: 80.h)),
    ),
  );
}
