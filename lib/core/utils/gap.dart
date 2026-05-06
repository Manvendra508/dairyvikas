import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gap {
  static Widget verticalGap(double gap) {
    return SizedBox(height: gap.h);
  }

  static Widget horizentalGap(double gap) {
    return SizedBox(width: gap.w);
  }
}
