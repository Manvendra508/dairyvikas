import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_container.dart';

class BannerWidget extends StatelessWidget {
  final String imagePath;
  const BannerWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 1.sw,
      height: 125.h,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
