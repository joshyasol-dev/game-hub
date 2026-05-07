import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bybet_mini/common/styles.dart';

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
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppStyles.primaryColor, width: 1.5),
        color: color ?? Colors.amber,
        image: imageBackground != null
            ? DecorationImage(
                image: imageBackground.contains('https')
                    ? NetworkImage(imageBackground)
                    : AssetImage(imageBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xFF111111),
                  BlendMode.softLight,
                ),
              )
            : null,
      ),
      height: 100.h,
      width: 110.w,
      child: Center(
        child: imageLogo.contains('https')
            ? Image.network(imageLogo, height: 60.h)
            : Image.asset(imageLogo, height: 60.h),
      ),
    ),
  );
}
