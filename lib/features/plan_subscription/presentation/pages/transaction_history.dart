import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_loader.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/retry_widget.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/model/transaction_model.dart';
import '../controllers/transaction_history_controller.dart'
    show TransactionHistoryController;

class TransactionHistory extends GetView<TransactionHistoryController>
    with CommonMixin {
  TransactionHistory({super.key});

  final TransactionHistoryController _transactionHistoryController =
      Get.find<TransactionHistoryController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.grey100,
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Visibility(
              visible: !_transactionHistoryController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_transactionHistoryController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () =>
                      _transactionHistoryController.getAllTransactionHistory(),
                ),

                child: Column(
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'Transaction History',
                      dairyName: AppState.dairyName.capitalize!,
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),
                    Gap.verticalGap(5),
                    Obx(
                      () => Row(
                        children: List.generate(
                          _transactionHistoryController.statusFilters.length,
                          (index) => _buildTransactionStatusFilter(
                            _transactionHistoryController
                                .statusFilters[index]['title'],
                            index,
                          ),
                        ),
                      ),
                    ),
                    Gap.verticalGap(5),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _transactionHistoryController
                            .filtredTransactions
                            .length,
                        itemBuilder: (context, index) => _buildTransactionCard(
                          _transactionHistoryController
                              .filtredTransactions[index],
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

  _buildTransactionCard(TransactionModel transaction) {
    return CommonContainer(
      shadowOpacity: 0.5,
      width: 1.sw,

      borderRaduis: 6.r,
      margin: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
      bordercolor: AppColors.grey200,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: _transactionHistoryController
                            .transactionColor(transaction.status)
                            .withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: AppIcons.premium2(
                          size: 20.sp,
                          color: _transactionHistoryController.transactionColor(
                            transaction.status,
                          ),
                        ),
                      ),
                    ),
                    Gap.horizentalGap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 190.w,
                          child: TextWidget(
                            maxline: 1,
                            text: transaction.paymentPlan.name,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.grey800,
                            fontSize: 14.sp,
                          ),
                        ),
                        Gap.verticalGap(2),

                        Row(
                          children: [
                            TextWidget(
                              text: formatDateTimeForUi(transaction.createdAt),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              textColor: AppColors.grey400,
                            ),
                            // Container(
                            //   width: 4.w,
                            //   height: 4.h,
                            //   margin: EdgeInsets.symmetric(horizontal: 4.w),
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: AppColors.grey300,
                            //   ),
                            // ),
                            // TextWidget(
                            //   text: '2:09 PM',
                            //   fontWeight: FontWeight.w500,
                            //   fontSize: 12.sp,
                            //   textColor: AppColors.grey400,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '₹${formatPrice(transaction.amount.toString())}',
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.grey800,
                      fontSize: 16.sp,
                    ),
                    Gap.verticalGap(2),
                    Container(
                      width: 70.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.r),
                        color: _transactionHistoryController
                            .transactionColor(transaction.status)
                            .withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: transaction.status,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,

                          textColor: _transactionHistoryController
                              .transactionColor(transaction.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Gap.verticalGap(6),
            Divider(thickness: 0.2),
            Gap.verticalGap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                  text:
                      'Txn Id : ${transaction.razorpayPaymentId.isEmpty ? 'unavailable' : '#${transaction.razorpayPaymentId}'}',
                  fontSize: 13.sp,
                  textColor: AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
                Gap.horizentalGap(10),
                transaction.razorpayPaymentId.isEmpty
                    ? SizedBox.shrink()
                    : InkWell(
                        onTap: () => copyText(transaction.razorpayPaymentId),
                        child: AppIcons.copy(),
                      ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     TextWidget(
            //       text: 'View Details',
            //       fontSize: 13.sp,
            //       fontWeight: FontWeight.w500,
            //     ),
            //     Visibility(
            //       visible: t['status'] == 'success',
            //       child: AppButton(
            //         title: 'Buy Again',
            //         isLoading: false.obs,
            //         buttonFontWeight: FontWeight.w600,
            //         buttonWidth: 90.w,
            //         buttonHeight: 21.h,
            //         buttonFontSize: 12.sp,
            //         buttonBorderRaduids: 6.r,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  _buildTransactionStatusFilter(String title, int index) {
    return Obx(() {
      RxBool isSelected =
          (_transactionHistoryController.currentStatusFilterIndex.value ==
                  index)
              .obs;
      return InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _transactionHistoryController.selectStatus(index);
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
                ? AppColors.themeColor.withValues(alpha: 0.2)
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
}
