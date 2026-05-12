import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/assets_paths.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/payment_cotnroller.dart';

class PaymentPage extends GetView<PaymentCotnroller> {
  final bool isPaymentSuccess;
  PaymentPage({super.key, required this.isPaymentSuccess});

  final PaymentCotnroller _paymentCotnroller = Get.find<PaymentCotnroller>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.grey100,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: isPaymentSuccess
                  ? _buildPaymentSuccessWidget()
                  : _buildPaymentFailedWidget(),
            ),
          ),
        ),
      ),
    );
  }

  _buildPaymentSuccessWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.verticalGap(10),

        Center(
          child: Column(
            children: [
              Gap.verticalGap(20),
              Stack(
                children: [
                  Lottie.asset(
                    AssetsPaths.paymentSuccessAnimation,
                    width: 150.w,
                    height: 150.h,
                  ),
                ],
              ),
              Gap.verticalGap(5),
              TextWidget(
                text: 'payment_success',
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                textColor: AppColors.grey800,
              ),
              Gap.verticalGap(2),
              TextWidget(
                textAlign: TextAlign.center,
                text: 'plan_upgrade_message',
                fontWeight: FontWeight.w600,
                fontSize: 12.5.sp,
                textColor: AppColors.grey500,
              ),
            ],
          ),
        ),
        Gap.verticalGap(25),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.verticalGap(16),
              TextWidget(
                text: 'transaction_details',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                textColor: AppColors.grey800,
              ),
              Gap.verticalGap(7),
              Container(
                width: 1.sw,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(width: 0.7, color: AppColors.grey300),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 12.w,
                  ),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      _buildInfoTextRow('txnt_id', '4Y 98Y 4Y48Y8'),

                      _buildInfoTextRow('d&t', '09 Mar 26, 09:00PM'),
                      _buildInfoTextRow('payment_method', 'Online'),
                      _buildInfoTextRow('plan', '1 year'),
                      _buildInfoTextRow('total_amount', '₹1999'),
                      _buildInfoTextRow('payment_status', '', hasIcon: true),

                      Divider(thickness: 0.2),
                      InkWell(
                        onTap: () => downloadPremiumReceipt(
                          txnId: '4Y 98Y 4Y48Y8',
                          dateTime: '09 Mar 26, 09:00PM',
                          paymentMethod: 'Online',
                          plan: '1 year',
                          amount: '₹1999',
                          status: 'paid',
                        ),
                        child: SizedBox(
                          width: 1.sw,
                          height: 30.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: AppIcons.download(
                                  color: AppColors.themeColor,
                                  size: 15.sp,
                                ),
                              ),
                              Gap.horizentalGap(6),
                              TextWidget(
                                text: 'download_receipt',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                textColor: AppColors.themeColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap.verticalGap(15),
        InkWell(
          onTap: () {
            Get.delete<DashboardController>();
            AppNavigation.goToDashboardPage();
          },
          child: AppButton(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            title: 'go_to_dashboard',
            isLoading: false.obs,
            buttonFontSize: 15.sp,
            buttonFontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Future<void> downloadPremiumReceipt({
    required String txnId,
    required String dateTime,
    required String paymentMethod,
    required String plan,
    required String amount,
    required String status,
  }) async {
    final pdf = pw.Document();

    // ✅ Load Font (for ₹ support)
    final font = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
    );

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// 🟢 Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Dairy Vikas",
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green,
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Text(
                      "SUCCESS",
                      style: pw.TextStyle(
                        font: font,
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              /// 💰 Amount Section
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      amount,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Payment Successful",
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              /// 📄 Transaction Details Box
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _row("Transaction ID", txnId, font),
                    _row("Date & Time", dateTime, font),
                    _row("Payment Method", paymentMethod, font),
                    _row("Plan", plan, font),
                    _row("Amount", amount, font),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              /// 🙏 Footer
              pw.Center(
                child: pw.Text(
                  "Thank you for choosing Dairy Vikas 🙏",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 11,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // 🔥 Reusable Row
  pw.Widget _row(String title, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: font,
              fontSize: 11,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildPaymentFailedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.verticalGap(10),

        Center(
          child: Column(
            children: [
              Gap.verticalGap(20),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.redColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.cancel,
                    color: AppColors.redColor,
                    size: 80.sp,
                  ),
                ),
              ),
              Gap.verticalGap(10),
              TextWidget(
                text: 'payment_failed',
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                textColor: AppColors.grey800,
              ),
              Gap.verticalGap(2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextWidget(
                  maxline: 4,
                  textAlign: TextAlign.center,
                  text: 'txs_fail_msg',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5.sp,
                  textColor: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
        Gap.verticalGap(25),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.verticalGap(16),
              TextWidget(
                text: 'transaction_details',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                textColor: AppColors.grey800,
              ),
              Gap.verticalGap(7),
              Container(
                width: 1.sw,

                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(width: 0.3, color: AppColors.grey300),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 12.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'amt',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            textColor: AppColors.grey500,
                          ),
                          TextWidget(
                            text: '₹1999.0',
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp,
                            textColor: AppColors.grey900,
                          ),
                        ],
                      ),
                      Container(
                        width: 60.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: AppColors.grey100,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.money,
                            size: 30.sp,
                            color: AppColors.grey300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap.verticalGap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 1.sw / 2.25,

                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(width: 0.3, color: AppColors.grey300),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'txnt_id_UP',
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                                textColor: AppColors.grey500,
                              ),
                              TextWidget(
                                text: 'KJDDNLSDSJND',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                textColor: AppColors.grey900,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw / 2.25,

                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(width: 0.3, color: AppColors.grey300),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'date_up',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                textColor: AppColors.grey500,
                              ),
                              TextWidget(
                                text: '24 OCT, 2026',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                textColor: AppColors.grey900,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Gap.verticalGap(20),
        Container(
          width: 1.sw,
          height: 70.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.themeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              width: 0.3,
              color: AppColors.themeColor.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 35.h,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: BoxDecoration(
                        color: AppColors.themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: AppIcons.customerSupport(
                          size: 20.sp,
                          color: AppColors.themeColor,
                        ),
                      ),
                    ),
                    Gap.horizentalGap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'need_help',
                          fontWeight: FontWeight.w600,
                          fontSize: 11.4.sp,
                          textColor: AppColors.grey900,
                        ),

                        Gap.verticalGap(1),
                        TextWidget(
                          text: 'support_msg',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          textColor: AppColors.themeColor,
                        ),
                      ],
                    ),
                  ],
                ),
                AppIcons.arrowForward(
                  color: AppColors.themeColor.withValues(alpha: 0.8),
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ),
        Gap.verticalGap(20),
        InkWell(
          onTap: () => _paymentCotnroller.retryPayment(),
          child: AppButton(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            title: 'retry_payment',
            isLoading: false.obs,
            buttonFontSize: 15.sp,
            buttonFontWeight: FontWeight.w700,
          ),
        ),
        Gap.verticalGap(20),
        SizedBox(
          width: 1.sw,
          height: 30.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextWidget(
                text: 'go_to_dashboard',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                textColor: AppColors.themeColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildInfoTextRow(String title, String value, {bool hasIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 13.sp,
          textColor: AppColors.grey600,
        ),
        hasIcon
            ? Container(
                width: 60.w,
                height: 18.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.greenColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: TextWidget(
                    text: 'success',
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    textColor: AppColors.greenColor,
                  ),
                ),
              )
            : TextWidget(
                text: value,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                textColor: AppColors.grey800,
              ),
      ],
    );
  }
}
