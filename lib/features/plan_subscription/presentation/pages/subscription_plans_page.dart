import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/plan_subscription/data/model/subscription_plan_model.dart';
import 'package:dairysathi/features/plan_subscription/presentation/controllers/subscription_plan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';

class SubscriptionPlansPage extends GetView<SubscriptionPlanController>
    with CommonMixin {
  SubscriptionPlansPage({super.key});

  final SubscriptionPlanController _subscriptionPlanController =
      Get.find<SubscriptionPlanController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.whiteColor,
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Visibility(
              visible: !_subscriptionPlanController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_subscriptionPlanController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _subscriptionPlanController.getAllPlans(),
                ),

                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.verticalGap(10),

                        DairySathiAppBar(
                          title: 'subscriptions',
                          dairyName: AppState.dairyName.capitalize!,
                        ),
                        Gap.verticalGap(6),
                        Divider(thickness: 0.2),
                        Column(
                          children: [
                            TextWidget(
                              text: 'choose_plan',
                              fontWeight: FontWeight.w700,
                              fontSize: 22.sp,
                              textColor: AppColors.grey800,
                            ),
                            Gap.verticalGap(2),
                            TextWidget(
                              textAlign: TextAlign.center,
                              text: 'choose_plan_msg',
                              fontWeight: FontWeight.w600,

                              textColor: AppColors.grey500,
                            ),
                          ],
                        ),
                        Gap.verticalGap(15),
                        Expanded(
                          child: GetBuilder<SubscriptionPlanController>(
                            builder: (controller) {
                              return Visibility(
                                visible: _subscriptionPlanController
                                    .subscriptionPlans
                                    .isNotEmpty,
                                replacement: _buildNotFoundDataWidget(),

                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _subscriptionPlanController
                                      .subscriptionPlans
                                      .length,
                                  itemBuilder: (context, index) {
                                    return _buildPlanWidget(
                                      index,
                                      _subscriptionPlanController
                                          .subscriptionPlans[index],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () =>
                          _subscriptionPlanController.isInitiatingPayment.value
                          ? Positioned.fill(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: AppColors.blackColor.withOpacity(0.5),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
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

  _buildPlanWidget(int index, SubscriptionPlanModel subscriptionPlan) {
    return Stack(
      children: [
        CommonContainer(
          shadowOpacity: 0.7,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          width: 1.sw,

          borderRaduis: 14.r,
          bordercolor: subscriptionPlan.isBestValue
              ? AppColors.themeColor
              : AppColors.grey200,
          borderWidth: subscriptionPlan.isBestValue ? 1 : 0.4,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          textColor: AppColors.grey700,
                          maxline: 8,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          text: '${subscriptionPlan.metaData['months']} Month',
                        ),
                        Gap.verticalGap(1),
                        TextWidget(
                          textColor: AppColors.grey500,
                          maxline: 8,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          text: subscriptionPlan.name,
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextWidget(
                          textColor: AppColors.themeColor,
                          maxline: 8,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w700,
                          text: '₹${subscriptionPlan.price}',
                        ),
                        Gap.verticalGap(1),
                        TextWidget(
                          textColor: AppColors.grey500,
                          maxline: 8,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          text: subscriptionPlan.metaData['months'] == '12'
                              ? "You saved ${subscriptionPlan.metaData['save_percent']}%"
                              : "",
                        ),
                      ],
                    ),
                  ],
                ),

                Gap.verticalGap(10),

                Column(
                  children: List.generate(subscriptionPlan.description.length, (
                    index,
                  ) {
                    final entry = subscriptionPlan.description.entries
                        .elementAt(index);

                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          // index == 4 || index == 5
                          //     ? Icon(
                          //         Icons.cancel,
                          //         color: AppColors.redColor.withOpacity(0.8),
                          //         size: 16.sp,
                          //       )
                          //     : Icon(
                          //         Icons.check_circle,
                          //         color: AppColors.themeColor,
                          //         size: 16.sp,
                          //       ),
                          Icon(
                            Icons.check_circle,
                            color: AppColors.themeColor,
                            size: 16.sp,
                          ),

                          SizedBox(width: 7.w),

                          Expanded(
                            child: TextWidget(
                              textColor: AppColors.grey600,
                              maxline: 8,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              text: entry.value, // ✅ FIXED
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Gap.verticalGap(30),
                InkWell(
                  onTap: () => _subscriptionPlanController.startPayment(
                    subscriptionPlan,
                  ),
                  child: AppButton(
                    shadowOpacity: 0.4,
                    title: 'upgrade_now',
                    buttonFontWeight: FontWeight.w700,
                    isLoading: false.obs,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: subscriptionPlan.isBestValue,
          child: Positioned(
            left: 1.sw / 2.7,
            top: 8,
            child: Container(
              width: 100.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              child: Center(
                child: TextWidget(
                  text: 'best_value',
                  textColor: AppColors.whiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildNotFoundDataWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_plans_found',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
