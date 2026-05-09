// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bybet_mini/common/styles.dart';

class AllGameWidget extends StatelessWidget {
  String gameUrl;
  String backgroundImg;
  String icon;
  String gameTitle;
  String desc;
  VoidCallback? ontap;
  AllGameWidget({
    super.key,
    required this.backgroundImg,
    required this.gameTitle,
    required this.gameUrl,
    required this.icon,
    required this.ontap,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppStyles.primaryColor,
                      width: .5.w,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    image: DecorationImage(
                      image: backgroundImg.contains('https')
                          ? NetworkImage(backgroundImg)
                          : AssetImage(backgroundImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: icon.contains('https')
                        ? Image.network(icon, height: 40.h)
                        : Image.asset(icon, height: 40.h),
                  ),
                ),
                SizedBox(width: 24.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      gameTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppStyles.darkPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 12.h,),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        desc,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.darkPrimaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
