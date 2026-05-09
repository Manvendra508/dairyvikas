import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/retry_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/invoices/presentation/controllers/invoice_details_controller.dart';
import 'package:DairyVikas/features/invoices/presentation/pages/inoivce_common_widgets/cattel_feed_card.dart';
import 'package:DairyVikas/features/invoices/presentation/pages/inoivce_common_widgets/deduction_details_card.dart';
import 'package:DairyVikas/features/invoices/presentation/pages/inoivce_common_widgets/invoicedetails_collection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_button.dart';
import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/text_widget.dart';
import '../../../../core/utils/app_icons.dart';

class InvoiceDetailsPage extends GetView<InvoiceDetailsController>
    with CommonMixin {
  final bool showRemoveButton;
  InvoiceDetailsPage({super.key, required this.showRemoveButton});

  final InvoiceDetailsController _invoiceDetailsController =
      Get.find<InvoiceDetailsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: AppColors.whiteColor.withOpacity(0.98),
        bottomNavigationBar: _buildTotalSummaryData(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          child: Obx(
            () => Visibility(
              visible: !_invoiceDetailsController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_invoiceDetailsController.hasError.value,

                replacement: RetryWidget(
                  onRetry: () => _invoiceDetailsController.getInvoiceDetails(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'invoice_details',
                      dairyName: AppState.dairyName.capitalize!,
                      trailingWidget: showRemoveButton
                          ? _buildAppBarButton(context)
                          : null,
                    ),
                    Gap.verticalGap(8),
                    Container(width: 1.sw, color: AppColors.grey100, height: 1),
                    Gap.verticalGap(8),

                    _buildUserCard(),
                    Gap.verticalGap(8),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            InvoicedetailsCollectionCard(
                              invoiceDetailsCollections:
                                  _invoiceDetailsController
                                      .invoiceDetailsCollections,
                            ),
                            Gap.verticalGap(8),
                            CattelFeedCard(
                              invoiceDetailsItemSales:
                                  _invoiceDetailsController.itemSaleList,
                            ),
                            Gap.verticalGap(8),
                            DeductionDetailsCard(),
                            Gap.verticalGap(10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildUserCard() {
    return CommonContainer(
      width: 1.sw,
      bordercolor: AppColors.whiteColor,
      shadowOpacity: 0.2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.verticalGap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcons.calendar(size: 12.sp, color: AppColors.grey700),
                Gap.horizentalGap(5),
                TextWidget(
                  textColor: AppColors.grey700,
                  maxline: 7,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,

                  text:
                      '${AppState.currentInvoiceForUpdate.periodStart} - ${AppState.currentInvoiceForUpdate.periodEnd}',
                ),
              ],
            ),
            Gap.verticalGap(3),
            Divider(thickness: 0.5, color: AppColors.grey200),
            Gap.verticalGap(3),

            TextWidget(
              text: AppState.currentInvoiceForUpdate.partyType.toUpperCase(),
              fontSize: 11.sp,
              textColor: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
            Gap.verticalGap(2),
            TextWidget(
              text: AppState.currentInvoiceForUpdate.partyName,
              fontSize: 15.sp,
              textColor: AppColors.grey800,
              fontWeight: FontWeight.w600,
            ),
            Gap.verticalGap(1),
            TextWidget(
              text: 'code_count'.trParams({'count': "3"}),
              fontSize: 11.sp,
              textColor: AppColors.grey500,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  _buildTotalSummaryData() {
    return Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Visibility(
          // visible: _invoiceDetailsController.filteredCollectionsList.isNotEmpty,
          visible: true,
          child: CommonContainer(
            borderRaduis: 0.r,
            width: 1.sw,
            height: _invoiceDetailsController.isShowFullDataOpen.value
                ? 195.h
                : 43.h,
            containerColor: AppColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap.verticalGap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: _invoiceDetailsController.isShowFullDataOpen.value
                            ? 'hide_full_data'
                            : 'show_full_data',
                        fontSize: 13.5.sp,
                        textColor: AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                      InkWell(
                        onTap: () =>
                            _invoiceDetailsController.isShowFullDataOpen.value =
                                !_invoiceDetailsController
                                    .isShowFullDataOpen
                                    .value,
                        child: Container(
                          width: 32.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor.withOpacity(0.8),
                          ),
                          child: Center(
                            child: AnimatedRotation(
                              turns:
                                  _invoiceDetailsController
                                      .isShowFullDataOpen
                                      .value
                                  ? 0.5
                                  : 0,
                              duration: const Duration(milliseconds: 250),
                              child: AppIcons.arrowUp(
                                size: 17,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _invoiceDetailsController.isShowFullDataOpen.value,
                    child: Column(
                      children: [
                        Gap.verticalGap(5),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 6.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryDataText(
                                  'total_collection_amount',
                                  AppColors.grey500,
                                  12.sp,
                                ),
                                _buildSummaryDataText(
                                  'food_or_item_amount',
                                  AppColors.grey500,
                                  12.sp,
                                ),
                                _buildSummaryDataText(
                                  'total_deduction',
                                  AppColors.grey500,
                                  12.sp,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 6.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryDataText(
                                  '₹${_invoiceDetailsController.totalCollectionAmount.toStringAsFixed(1)}',
                                  AppColors.grey800,
                                  fontweight: FontWeight.w600,
                                  13.sp,
                                ),
                                _buildSummaryDataText(
                                  '₹${_invoiceDetailsController.totalItemSaleAmount.toStringAsFixed(1)}',
                                  AppColors.grey800,
                                  fontweight: FontWeight.w600,
                                  13.sp,
                                ),
                                _buildSummaryDataText(
                                  '₹0.0',
                                  AppColors.redColor.withOpacity(0.8),
                                  fontweight: FontWeight.w600,
                                  13.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap.verticalGap(7),
                        Divider(color: AppColors.grey100),
                        Gap.verticalGap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryDataText(
                              'amount_due',
                              AppColors.grey800,
                              17.sp,
                              fontweight: FontWeight.w600,
                            ),
                            _buildSummaryDataText(
                              _invoiceDetailsController.finalAmount.isNegative
                                  ? '- ₹${(-1 * _invoiceDetailsController.finalAmount).toStringAsFixed(1)}'
                                  : '₹${_invoiceDetailsController.finalAmount.toStringAsFixed(1)}',
                              _invoiceDetailsController.finalAmount.isNegative
                                  ? AppColors.redColor
                                  : AppColors.themeColor,
                              17.sp,
                              fontweight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Gap.verticalGap(5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSummaryDataText(
    String text,
    Color color,
    double fSize, {
    FontWeight? fontweight,
  }) {
    return Row(
      children: [
        TextWidget(
          text: text,
          fontSize: fSize.sp,
          textColor: color,
          fontWeight: fontweight ?? FontWeight.w500,
        ),
      ],
    );
  }

  _buildAppBarButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _invoiceDetailsController.showDeleteInvoiceOption(context);
      },
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 75.w,
        buttonHeight: 25.h,
        title: 'remove',
        buttonFontSize: 12.sp,
        shadowOpacity: 0.6,
        buttonBorderColor: AppColors.redColor.withOpacity(0.8),
        buttonColor: AppColors.redColor.withOpacity(0.8),
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }
}
