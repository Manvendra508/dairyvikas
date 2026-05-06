import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:dairysathi/features/milk_suppliers/data/model/milk_supplier_model.dart';
import 'package:dairysathi/features/milk_suppliers/presentation/controllers/milk_supplier_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MilkSupplierDetails extends GetView<MilkSupplierDetailsController>
    with CommonMixin {
  final MilkSupplierModel milkSupplier;
  MilkSupplierDetails({super.key, required this.milkSupplier});

  final MilkSupplierDetailsController _detailsController =
      Get.find<MilkSupplierDetailsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.verticalGap(10),

                DairySathiAppBar(
                  title: 'supplier_details',
                  dairyName: AppState.dairyName.capitalize!,
                  trailingWidget: _buildAppBarButton(),
                ),
                Gap.verticalGap(6),

                Divider(thickness: 0.2),
                Gap.verticalGap(6),

                CommonContainer(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 1.sw,

                  containerColor: AppColors.whiteColor,

                  bordercolor: AppColors.themeColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: 25.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleTextwidget('supplier_code'),
                            _buildTitleTextwidget('full_name'),

                            _buildTitleTextwidget('supplier_mobile'),

                            //  _buildTitleTextwidget('supplier_email'),
                            _buildTitleTextwidget('milk_type'),
                            _buildTitleTextwidget('status'),
                            _buildTitleTextwidget('added_on'),
                          ],
                        ),

                        Gap.horizentalGap(12.w),

                        Expanded(
                          flex: 5,
                          child: Column(
                            spacing: 25.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildValueTextwidget(
                                milkSupplier.milkSupplierCode,
                                1,
                              ),
                              _buildValueTextwidget(
                                milkSupplier.supplierName,
                                2,
                              ),

                              _buildValueTextwidget(
                                '+91-${milkSupplier.supplierMobile}',
                                4,
                                phone: milkSupplier.supplierMobile,
                              ),
                              // _buildValueTextwidget(
                              //   milkSupplier.email.isEmpty
                              //       ? 'unavailable'
                              //       : milkSupplier.email,
                              //   5,
                              // ),
                              _buildValueTextwidget(
                                getMilkType(milkSupplier.milkTypeId),
                                6,
                              ),

                              _buildValueTextwidget(
                                milkSupplier.status ? 'active' : "inactive",
                                7,
                              ),
                              _buildValueTextwidget(
                                formatDate(milkSupplier.createdAt),
                                8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildRateChart(),

                InkWell(
                  onTap: () {
                    if (_detailsController.isDeleting.value) return;
                    _detailsController.showDeleteSupplierOption(
                      context,
                      milkSupplier.id,
                      milkSupplier.supplierName,
                    );
                  },
                  child: Obx(
                    () => CommonContainer(
                      width: 1.sw,
                      height: 40.h,
                      containerColor: AppColors.whiteColor,
                      bordercolor: AppColors.redColor.withOpacity(0.7),

                      margin: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      child: Center(
                        child: Visibility(
                          visible: !_detailsController.isDeleting.value,
                          replacement: SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.redColor.withOpacity(0.8),
                            ),
                          ),
                          child: TextWidget(
                            text: 'remove_supplier',
                            fontSize: 16.sp,
                            textColor: AppColors.redColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRateChart() {
    return CommonContainer(
      width: 1.sw,
      containerColor: AppColors.whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          Container(
            height: 35.h,
            width: 1.sw,
            decoration: BoxDecoration(
              color: AppColors.themeColor.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Center(
              child: TextWidget(
                text: 'rate_chart',
                textColor: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
          Gap.verticalGap(10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 4, child: _buildTitleTextwidget('cow')),
                    Expanded(flex: 4, child: _buildValueTextwidget('CM', null)),
                    Expanded(
                      flex: 1,
                      child: AppIcons.arrowForward(
                        size: 13,
                        color: AppColors.themeColor,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 0.5, color: AppColors.grey200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 4, child: _buildTitleTextwidget('buffalo')),
                    Expanded(flex: 4, child: _buildValueTextwidget('BM', null)),
                    Expanded(
                      flex: 1,
                      child: AppIcons.arrowForward(
                        size: 13,
                        color: AppColors.themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTitleTextwidget(String title) {
    return TextWidget(
      text: title,
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      textColor: AppColors.grey500,
    );
  }

  _buildValueTextwidget(String value, int? id, {String? phone}) {
    return Row(
      children: [
        TextWidget(
          text: value,
          fontWeight: FontWeight.w500,
          fontSize: value.length > 28 ? 10.sp : 12.sp,
          textColor: AppColors.grey800,
        ),
        id == 4
            ? Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: InkWell(
                  onTap: () => phone == null ? () {} : makePhoneCall(phone),
                  child: AppIcons.call(size: 11, color: AppColors.themeColor),
                ),
              )
            : id == 6 || id == 7
            ? Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: TextWidget(
                  text: 'edit',
                  textColor: AppColors.blue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox.fromSize(),
      ],
    );
  }

  _buildAppBarButton() {
    return InkWell(
      onTap: () {
        AppState.currentSupplierForUpdate = milkSupplier;
        AppState.isSupplierEdit = true;
        AppNavigation.goToAddMilkSupplierPage();
      },
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 75.w,
        buttonHeight: 28.h,
        title: 'update',
        buttonFontSize: 13.sp,
        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }
}
