import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../controllers/customer_pdf_sheet_controller.dart';

class CustomerPdfSheet extends GetView<CustomerPdfSheetController>
    with CommonMixin {
  CustomerPdfSheet({super.key});

  final CustomerPdfSheetController _customerPdfSheetController =
      Get.find<CustomerPdfSheetController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.verticalGap(10),

              DairySathiAppBar(
                title: 'customer_collection_pdf',
                dairyName: AppState.dairyName.capitalize!,
              ),
              Gap.verticalGap(6),

              Divider(thickness: 0.2),
              Gap.verticalGap(6),

              Container(
                // color: AppColors.whiteColor,
                // width: 1.sw,
                // height: 1.sh,
                child: Expanded(
                  child: PdfPreview(
                    pdfPreviewPageDecoration: BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                    actionBarTheme: PdfActionBarTheme(
                      backgroundColor: AppColors.themeColor,
                    ),
                    build: (format) async =>
                        _customerPdfSheetController.generateCustomerPdf(
                          dairyName: 'Rathore dairy',
                          dairyLocation: 'Jaipur, Rajasthan',
                          title: 'Customer collection sheet',
                          isCow: true,
                          isBuffalo: true,
                          isMorning: false,
                          isEvening: true,
                        ),
                    allowPrinting: true,
                    allowSharing: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
