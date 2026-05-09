import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CacheMyNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double? errorhIconHeight;
  final double? imgRaduis;
  final double? iconWidth;
  final double? iconHeight;
  final BoxFit? fit;
  final double? loaderSize;
  const CacheMyNetworkImage({
    super.key,
    required this.imgUrl,
    this.errorhIconHeight,
    this.imgRaduis,
    this.iconHeight,
    this.iconWidth,
    this.fit,
    this.loaderSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(imgRaduis ?? 0.r),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        height: iconHeight ?? 26.h,
        width: iconWidth ?? 26.w,
        imageUrl: imgUrl,
        fit: fit,
        placeholder: (context, url) => SizedBox(
          width: loaderSize ?? 20.w,
          height: loaderSize ?? 20.h,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: AppColors.grey600,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AssetsPaths.errorImage,
          height: errorhIconHeight ?? 25.h,
          color: AppColors.grey300,
        ),
      ),
    );
  }
}
