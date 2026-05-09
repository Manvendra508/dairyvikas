import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? textColor;
  final Color? decorationColor;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final int? maxline;

  const TextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.textColor,
    this.fontWeight,
    this.textAlign,
    this.maxline,
    this.decorationColor,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    //  fonts
    // 1.inter
    // 2.montserrat
    // 3.poppins

    return Text(
      text.tr,
      maxLines: maxline ?? 2,
      textAlign: textAlign ?? TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 14.sp,
        color: textColor ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration,
        decorationColor: decorationColor,
      ),
    );
  }
}
