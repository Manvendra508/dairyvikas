import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/core/utils/assets_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIcons {
  AppIcons._();

  static Widget copy({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.copy,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget arrowDown({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.arrowDown,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget arrowBack({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.arrrowBack,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget arrowUp({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.arrowUp,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget visible({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.visible,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget visiblityHide({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.invisible,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget camera({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.camera,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget gallary({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.gallary,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget profileIcon({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.profileIcon, height: size.h, color: color);
  }

  static Widget profilePlaceHolder({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.profilePlaceHolder,
      height: size.h,
      color: color,
    );
  }

  static Widget arrowForward({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.arrowRight,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget arrowForwardRange({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.arrowRange,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget location({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.location,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget settings({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.setting,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget errrorImage({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.errorImage,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget check({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.verify,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget remove({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.remove, height: size.h, color: color);
  }

  static Widget cow({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.cow, height: size.h, color: color);
  }

  static Widget buffalo({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.buffalo, height: size.h, color: color);
  }

  static Widget cross({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.cross, height: size.h, color: color);
  }

  static Widget call({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.call,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget search({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.search,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget coloredCalander({double size = 13}) {
    return Image.asset(AssetsPaths.coloredCalendar, height: size.h);
  }

  static Widget calendar({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.calendar,
      height: size.h,
      color: color ?? AppColors.textSecondary,
    );
  }

  static Widget sort({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.sort, height: size.h, color: color);
  }

  static Widget more({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.more, height: size.h, color: color);
  }

  static Widget info({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.info, height: size.h, color: color);
  }

  static Widget milkSeller({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.milkSellerIcon,
      height: size.h,
      color: color,
    );
  }

  static Widget morning({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.morning, height: size.h, color: color);
  }

  static Widget evening({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.evening, height: size.h, color: color);
  }

  static Widget longArrow({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.longArrow, height: size.h, color: color);
  }

  static Widget add({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.add, height: size.h, color: color);
  }

  static Widget bill({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.bill, height: size.h, color: color);
  }

  static Widget khata({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.khata, height: size.h, color: color);
  }

  static Widget milkbuyers({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.milkbuyers, height: size.h, color: color);
  }

  static Widget phoneBook({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.phoneBook, height: size.h, color: color);
  }

  static Widget units({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.units, height: size.h, color: color);
  }

  static Widget stock({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.stock, height: size.h, color: color);
  }

  static Widget edit({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.edit, height: size.h, color: color);
  }

  static Widget history({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.history, height: size.h, color: color);
  }

  static Widget expired({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.expired, height: size.h, color: color);
  }

  static Widget acitve({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.active, height: size.h, color: color);
  }

  static Widget payableArrow({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.arrowUpSide, height: size.h, color: color);
  }

  static Widget userAdd({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.addUser, height: size.h, color: color);
  }

  static Widget genrate({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.genarate, height: size.h, color: color);
  }

  static Widget paid({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.paid, height: size.h, color: color);
  }

  static Widget pending({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.pending, height: size.h, color: color);
  }

  static Widget lock({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.lock, height: size.h, color: color);
  }

  static Widget paymentSuccess({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.paymentSuccess,
      height: size.h,
      color: color,
    );
  }

  static Widget download({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.download, height: size.h, color: color);
  }

  static Widget scan({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.scan, height: size.h, color: color);
  }

  static Widget printer({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.printer, height: size.h, color: color);
  }

  static Widget aboutus({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.about, height: size.h, color: color);
  }

  static Widget refer({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.referIcon, height: size.h, color: color);
  }

  static Widget transaction({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.transaction, height: size.h, color: color);
  }

  static Widget premium({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.premium, height: size.h, color: color);
  }

  static Widget premium2({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.premium2, height: size.h, color: color);
  }

  static Widget appUpdate({double size = 13, Color? color}) {
    return Image.asset(AssetsPaths.appUpdate, height: size.h, color: color);
  }

  static Widget customerSupport({double size = 13, Color? color}) {
    return Image.asset(
      AssetsPaths.cusotmerSupport,
      height: size.h,
      color: color,
    );
  }
}
