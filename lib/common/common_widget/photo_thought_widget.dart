import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/network_image.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PhotoThoughtWidget extends StatefulWidget {
  const PhotoThoughtWidget({super.key});

  @override
  State<PhotoThoughtWidget> createState() => _PhotoThoughtWidgetState();
}

class _PhotoThoughtWidgetState extends State<PhotoThoughtWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> progressAnimation;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(progressController)
          ..addListener(() {
            if (progressAnimation.value == 1.0) {
              AppNavigation.goBack();
            }
          });
    progressController.forward();
  }

  void pauseProgress() {
    setState(() {
      progressController.stop();
    });
  }

  void resumeProgress() {
    setState(() {
      if (progressController.isDismissed || progressController.isCompleted) {
        return;
      }

      progressController.forward();
    });
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () => pauseProgress(),
          onLongPressEnd: (v) => resumeProgress(),
          child: Container(
            width: 1.sw,
            height: 650.h,
            margin: EdgeInsets.only(top: 0.h),
            decoration: BoxDecoration(color: AppColors.grey900),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 80.h,
                bottom: 10.h,
              ),

              child: CacheMyNetworkImage(
                fit: BoxFit.cover,
                iconHeight: 1.sh,
                iconWidth: 1.sw,
                imgRaduis: 6.r,
                imgUrl:
                    'https://live.staticflickr.com/1567/25644818033_cfcd9f99f5_b.jpg',
              ),
            ),
          ),
        ),
        Positioned(
          top: 35.h,
          right: 3.w,
          left: 3.w,
          child: Column(
            children: [
              SizedBox(
                width: 1.sw,
                child: AnimatedBuilder(
                  animation: progressController,
                  builder: (context, _) {
                    return LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 2.0,
                      percent: progressAnimation.value,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: AppColors.whiteColor,
                    );
                  },
                ),
              ),

              Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 30.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CacheMyNetworkImage(
                      fit: BoxFit.fill,
                      iconHeight: 22.h,
                      iconWidth: 32.w,
                      imgRaduis: 100.r,
                      imgUrl:
                          'https://live.staticflickr.com/1567/25644818033_cfcd9f99f5_b.jpg',
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Rathore dairy',

                        fontWeight: FontWeight.w600,
                        textColor: AppColors.whiteColor,
                      ),
                      TextWidget(
                        text: '22h ago',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey300,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
