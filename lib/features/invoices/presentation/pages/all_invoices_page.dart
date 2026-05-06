import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/invoices/data/model/invoice_model.dart';
import 'package:dairysathi/features/invoices/presentation/controllers/all_invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';

class AllInvoicesPage extends GetView<AllInvoiceController> with CommonMixin {
  AllInvoicesPage({super.key});

  final AllInvoiceController _allInvoiceController =
      Get.find<AllInvoiceController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allInvoiceController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_allInvoiceController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _allInvoiceController.getAllInvoices(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairySathiAppBar(
                      title: 'customer_invoices',
                      dairyName: AppState.dairyName.capitalize!,
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    Gap.verticalGap(6),

                    _buildDateFilter(context),
                    Gap.verticalGap(10),
                    Obx(
                      () => Row(
                        children: List.generate(
                          _allInvoiceController.statusFilters.length,
                          (index) => _buildInvoiceStatusFilter(
                            _allInvoiceController.statusFilters[index]['title'],
                            index,
                          ),
                        ),
                      ),
                    ),

                    Gap.verticalGap(10),
                    _buildTextFormFieldForSearchInvoice(),
                    Gap.verticalGap(10),
                    Expanded(
                      child: GetBuilder<AllInvoiceController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _allInvoiceController
                                .filteredInvoicesList
                                .isNotEmpty,
                            replacement: _buildNotFounddataWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _allInvoiceController
                                  .filteredInvoicesList
                                  .length,
                              itemBuilder: (context, index) {
                                return _buidInvoiceCard(
                                  _allInvoiceController
                                      .filteredInvoicesList[index],
                                );
                              },
                            ),
                          );
                        },
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

  _buildDateFilter(BuildContext context) {
    return InkWell(
      onTap: () => showMyBottomSheet(
        context,
        _buildDateRangeWidget('select_date_range'),
      ),
      child: CommonContainer(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: 1.sw,
        height: 38.h,
        containerColor: AppColors.whiteColor,
        bordercolor: AppColors.grey300,
        shadowOpacity: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppIcons.calendar(size: 14, color: AppColors.themeColor),
                  Gap.horizentalGap(10),
                  TextWidget(
                    text: _allInvoiceController.selectedDateRange.isEmpty
                        ? 'no_date_range_available'
                        : '${_allInvoiceController.selectedDateRange['start']} - ${_allInvoiceController.selectedDateRange['end']}',
                    fontSize: 13.sp,
                    textColor: AppColors.grey900,

                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              TextWidget(
                text: 'change',
                fontSize: 12.sp,
                textColor: AppColors.themeColor,

                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDateRangeWidget(String title) {
    return Container(
      width: 1.sw,
      height: 0.6.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppIcons.cross(),
                ),
              ],
            ),
            Gap.verticalGap(4.h),
            Divider(thickness: 0.7, color: AppColors.grey200),
            Gap.verticalGap(4.h),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    AppState.dateRanges.length,
                    (index) => InkWell(
                      onTap: () => _allInvoiceController.selectDateRange(index),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.h),
                        width: 1.sw,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color:
                              _allInvoiceController
                                      .currentDateRangeIndex
                                      .value ==
                                  index
                              ? AppColors.themeColor.withOpacity(0.02)
                              : AppColors.whiteColor,
                          border: Border.all(
                            width: 0.4,
                            color:
                                _allInvoiceController
                                        .currentDateRangeIndex
                                        .value ==
                                    index
                                ? AppColors.themeColor
                                : AppColors.whiteColor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                text: AppState.dateRanges[index]['start'],
                              ),
                              TextWidget(
                                text: '-',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.h,
                              ),

                              TextWidget(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                text: AppState.dateRanges[index]['end'],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buidInvoiceCard(InvoiceModel invoice) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            AppState.currentInvoiceForUpdate = invoice;
            AppNavigation.goToInvoiceDetailsPage(
              AppState.currentInvoiceForUpdate.status ==
                  _allInvoiceController.invoiceGenratedStatusKey,
            );
          },
          child: CommonContainer(
            shadowOpacity: 0.1,
            margin: EdgeInsets.only(top: 4.h, left: 5.w, right: 5.w),
            width: 1.sw,

            borderRaduis: 4.r,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.h,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.themeColor.withOpacity(0.06),
                          // border: Border.all(width: 0.6, color: AppColors.themeColor),
                        ),
                        child: Center(
                          child: TextWidget(
                            text: invoice.partyName.isEmpty
                                ? ''
                                : invoice.partyName
                                      .substring(0, 1)
                                      .toUpperCase(),

                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            textColor: AppColors.themeColor,
                          ),
                        ),
                      ),
                      Gap.horizentalGap(0.02.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 190.w,
                            child: TextWidget(
                              text: invoice.partyName.capitalizeFirst!,
                              textColor: AppColors.grey800,

                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.verticalGap(2.h),
                          Row(
                            children: [
                              TextWidget(
                                text: 'food_or_item_amount',
                                fontSize: 11.5.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w500,
                              ),
                              TextWidget(
                                text: '₹${invoice.itemSaleAmount}',
                                fontSize: 11.sp,
                                textColor: AppColors.grey800,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Gap.verticalGap(2.h),
                          Row(
                            children: [
                              TextWidget(
                                text: 'user',
                                fontSize: 12.sp,
                                textColor: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),
                              TextWidget(
                                text: invoice.partyType.capitalizeFirst!,
                                fontSize: 12.sp,
                                textColor: AppColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7.w),
                                width: 1.2,
                                height: 11.h,
                                color: AppColors.grey300,
                              ),
                              TextWidget(
                                text: 'status_dynamic',
                                fontSize: 12.sp,
                                textColor: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),

                              TextWidget(
                                text: _allInvoiceController.getInvoiceStatus(
                                  invoice.status,
                                ),
                                fontSize: 12.sp,
                                textColor: _allInvoiceController
                                    .getInvoiceStatusColor(invoice.status),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap.verticalGap(5),
                  Divider(thickness: 0.5, color: AppColors.grey200),
                  Gap.verticalGap(3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'amount_dynamic'.trParams({
                          "amount":
                              "₹${_allInvoiceController.getInvoiceAmount(invoice)}",
                        }),

                        textColor: AppColors.grey800,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          _buildMarkPaidButton(
                            invoice.status ==
                                _allInvoiceController.invoiceGenratedStatusKey,
                            invoice,
                          ),
                          _buildMarkUnPaidButton(
                            invoice.status ==
                                _allInvoiceController.invoicePaidStatusKey,
                            invoice,
                          ),
                          _buildGenrateInvoiceButton(
                            invoice.status ==
                                _allInvoiceController.invociePendingStatusKey,
                            invoice,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: invoice.status == _allInvoiceController.invociePendingStatusKey
              ? Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warning.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.history,
                      color: AppColors.warning,
                      size: 15.sp,
                    ),
                  ),
                )
              : invoice.status == _allInvoiceController.invoiceGenratedStatusKey
              ? SizedBox.shrink()
              : Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.themeColor.withOpacity(0.8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                      size: 14.sp,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  _buildGenrateInvoiceButton(bool show, InvoiceModel invoice) {
    return Visibility(
      visible: show,
      replacement: SizedBox.shrink(),
      child: InkWell(
        onTap: () => _allInvoiceController.genrateInvoice(invoice),
        child: Container(
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.themeColor.withOpacity(0.1),
            border: Border.all(width: 0.5, color: AppColors.themeColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                AppIcons.genrate(color: AppColors.themeColor, size: 11.sp),
                Gap.horizentalGap(5),
                TextWidget(
                  text: 'genrate_invoice',
                  fontSize: 12.sp,
                  textColor: AppColors.themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildMarkPaidButton(bool show, InvoiceModel invoice) {
    return Visibility(
      visible: show,
      replacement: SizedBox.shrink(),
      child: InkWell(
        onTap: () => _allInvoiceController.markPaidInvoice(invoice),
        child: Container(
          // width: 90.w,
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.blue.withOpacity(0.1),
            border: Border.all(width: 0.5, color: AppColors.blue),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Center(
              child: TextWidget(
                text: _allInvoiceController.getButtonDynamicText(invoice),
                fontSize: 12.sp,
                textColor: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildMarkUnPaidButton(bool show, InvoiceModel invoice) {
    return Visibility(
      visible: show,
      replacement: SizedBox.shrink(),
      child: InkWell(
        onTap: () => _allInvoiceController.markUnPaidInvoice(invoice),
        child: Container(
          // width: 90.w,
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.blue.withOpacity(0.1),
            border: Border.all(width: 0.5, color: AppColors.blue),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Center(
              child: TextWidget(
                text: 'mark_unpaid',
                fontSize: 12.sp,
                textColor: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildInvoiceStatusFilter(String title, int index) {
    return Obx(() {
      RxBool isSelected =
          (_allInvoiceController.currentStatusFilterIndex.value == index).obs;
      return InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _allInvoiceController.selectStatus(index);
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 14.w : 8.w,
            top: 4.h,
            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isSelected.value
                ? AppColors.themeColor.withOpacity(0.2)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextWidget(
                text: title,
                fontSize: 10.sp,
                textColor: isSelected.value
                    ? AppColors.themeColor
                    : AppColors.grey600,
                fontWeight: isSelected.value
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  _buildNotFounddataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_invoice_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildTextFormFieldForSearchInvoice() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _allInvoiceController.searchController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) => _allInvoiceController.searchInvoice(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 13.5.h,
                horizontal: 25.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.themeColor.withOpacity(0.4),
                ),
              ),

              hint: TextWidget(
                text: 'search_invoice_by_name_or_code',
                fontSize: 13.sp,
                textColor: AppColors.grey300,
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 20,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }
}
