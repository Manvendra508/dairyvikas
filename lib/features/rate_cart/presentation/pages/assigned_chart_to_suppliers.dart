import 'package:dairysathi/app/extensions/string_ext.dart';
import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/app_bar.dart';
import 'package:dairysathi/common/common_widget/app_button.dart';
import 'package:dairysathi/common/common_widget/check_box_widget.dart';
import 'package:dairysathi/common/common_widget/common_container.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';
import '../../../../core/local_datasources/app_state.dart';
import '../../data/model/assignable_supplier_model.dart';
import '../controllers/assign_chart_to_suppliers_controller.dart';

class AssignedChartToSuppliers extends GetView<AssignChartToSuppliersController>
    with CommonMixin {
  AssignedChartToSuppliers({super.key});

  final AssignChartToSuppliersController _assignChartToSuppliersController =
      Get.find<AssignChartToSuppliersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //  floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (),
        //   backgroundColor: AppColors.themeColor,
        //   child: Icon(Icons.add, color: AppColors.whiteColor, size: 30),
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Obx(
            () => Visibility(
              visible: !_assignChartToSuppliersController.isLoading.value,
              replacement: DairySathiLoader(),
              child: Visibility(
                visible: !_assignChartToSuppliersController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _assignChartToSuppliersController
                      .getAllRateAssignableSuppliers(),
                ),
                child: Column(
                  children: [
                    Gap.verticalGap(7),
                    DairySathiAppBar(
                      title: 'assign_rate_chart',
                      dairyName: AppState.dairyName,
                      trailingWidget:
                          _assignChartToSuppliersController
                              .filteredAssignedToChartSuppliers
                              .isEmpty
                          ? null
                          : _buildAppBarButton(),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    Visibility(
                      visible: _assignChartToSuppliersController
                          .filteredAssignedToChartSuppliers
                          .isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildTextFormFieldForSearchMilkSupplier(
                                true,
                                borderRaduis: 6.r,
                                width: 264.w,
                                height: 32.h,
                              ),
                              Gap.horizentalGap(2),
                              InkWell(
                                onTap: () {
                                  if (_assignChartToSuppliersController
                                      .filteredUnAssignedToChartSuppliers
                                      .isEmpty) {
                                    showAppToastMessage(
                                      'no_unassigned_supplier',
                                      true,
                                    );
                                  } else {
                                    showMyBottomSheet(
                                      context,
                                      _buildUnAssignedSuppliersList(
                                        'select_to_assign',
                                      ),
                                    );
                                  }
                                },
                                child: AppButton(
                                  buttonBorderRaduids: 6.r,
                                  buttonWidth: 70.w,

                                  buttonHeight: 30.h,
                                  title: 'add',
                                  buttonColor: AppColors.themeColor,
                                  buttonBorderColor: AppColors.themeColor,
                                  shadowOpacity: 0.6,
                                  buttonFontWeight: FontWeight.w600,
                                  isLoading: _assignChartToSuppliersController
                                      .isAssigning,
                                ),
                              ),
                            ],
                          ),

                          Gap.verticalGap(20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: 'assigned_dynamic'.trParams({
                                    "count":
                                        "${_assignChartToSuppliersController.filteredAssignedToChartSuppliers.length}",
                                  }),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                Obx(
                                  () => TextWidget(
                                    text: 'selected_dynamic'.trParams({
                                      "count":
                                          "${_assignChartToSuppliersController.toBeUnAssignsuppliersIds.length}",
                                    }),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _assignChartToSuppliersController
                                      .selectAllToUnAssign(),
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text: 'selecte_all',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Gap.horizentalGap(4),
                                      CheckBoxWidget(
                                        isSelected:
                                            _assignChartToSuppliersController
                                                .isSelectAllToUnAssign,
                                        width: 13.h,
                                        height: 13.h,
                                        radius: 2.r,
                                        chekHeight: 12.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap.verticalGap(8),
                    Expanded(
                      child: GetBuilder<AssignChartToSuppliersController>(
                        builder: (controller) {
                          return Visibility(
                            visible: _assignChartToSuppliersController
                                .filteredAssignedToChartSuppliers
                                .isNotEmpty,
                            replacement: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextWidget(
                                      text:
                                          AppState.customerTypeForassignablSupplierScreen ==
                                              AppState.supplierCustomerType
                                          ? 'no_assigned_supplier'
                                          : 'no_assigned_buyer',
                                      fontSize: 14.sp,
                                      textColor: AppColors.grey600,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                    ),
                                    Gap.verticalGap(10),
                                    InkWell(
                                      onTap: () => showMyBottomSheet(
                                        context,
                                        _buildUnAssignedSuppliersList(
                                          'select_to_assign',
                                        ),
                                      ),
                                      child: AppButton(
                                        buttonWidth: 100.w,
                                        buttonHeight: 30.h,
                                        shadowOpacity: 0.6,
                                        buttonBorderRaduids: 6.r,
                                        title: 'assign',
                                        buttonFontWeight: FontWeight.w600,
                                        buttonFontSize: 12.sp,
                                        isLoading: false.obs,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: _assignChartToSuppliersController
                                  .filteredAssignedToChartSuppliers
                                  .length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  _buildAlreadyAssignedSuppliersCard(
                                    _assignChartToSuppliersController
                                        .filteredAssignedToChartSuppliers[index],
                                    index,
                                  ),
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

  _buildUnAssignedSuppliersList(String title) {
    return Container(
      width: 1.sw,
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.07),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
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
            _buildTextFormFieldForSearchMilkSupplier(
              false,
              contentPadding: 23.5,
            ),
            Gap.verticalGap(10.h),
            _buildDropdownField(
              hint: 'select_chart_shift',
              items: AppState.shifts,
              selectedValue: _assignChartToSuppliersController.selectedShift,
            ),
            Gap.verticalGap(22.h),
            Visibility(
              visible: _assignChartToSuppliersController
                  .filteredUnAssignedToChartSuppliers
                  .isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _assignChartToSuppliersController
                        .showAllSelectedUnAssignedSupplier(),
                    child: Row(
                      children: [
                        CheckBoxWidget(
                          isSelected:
                              _assignChartToSuppliersController.showSelected,
                          width: 13.h,

                          height: 13.h,
                          radius: 2.r,
                          chekHeight: 12.sp,
                        ),
                        Gap.horizentalGap(4),
                        TextWidget(
                          text: 'show_selected',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => TextWidget(
                      text: 'selected_dynamic'.trParams({
                        "count":
                            "${_assignChartToSuppliersController.toBeAssignsuppliersIds.length}",
                      }),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _assignChartToSuppliersController.selectAllToAssign(),
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'selecte_all',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap.horizentalGap(4),
                        CheckBoxWidget(
                          isSelected: _assignChartToSuppliersController
                              .isSelectAllToAssign,
                          width: 13.h,
                          height: 13.h,
                          radius: 2.r,
                          chekHeight: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap.verticalGap(2.h),

            Expanded(
              child: GetBuilder<AssignChartToSuppliersController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: _assignChartToSuppliersController
                        .filteredUnAssignedToChartSuppliers
                        .length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        _buildUnAssignedSuppliersCard(
                          _assignChartToSuppliersController
                              .filteredUnAssignedToChartSuppliers[index],
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDropdownField({
    required String hint,
    required List<Map<String, dynamic>> items,
    required RxMap<String, dynamic> selectedValue,
  }) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 260.w,
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(width: 0.8, color: AppColors.lightBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Map<String, dynamic>>(
                value: selectedValue.value.isEmpty ? null : selectedValue.value,
                isExpanded: true,
                hint: TextWidget(
                  text: hint,
                  fontSize: 12.sp,
                  textColor: AppColors.textLight,
                ),
                items: items.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: TextWidget(
                      text: e['name'],
                      textColor: AppColors.blackColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  selectedValue.value = value;
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          Gap.horizentalGap(7),
          _buildSaveButton(),
        ],
      ),
    );
  }

  _buildUnAssignedSuppliersCard(AssignableSupplierModel supplier) {
    return InkWell(
      onTap: () => _assignChartToSuppliersController
          .selectSingleSuppliersToAssignRatechart(supplier),
      child: CommonContainer(
        containerColor: supplier.isSelected.value
            ? AppColors.themeColor.withOpacity(0.05)
            : AppColors.whiteColor,

        margin: EdgeInsets.only(top: 7.h),
        height: 50.h,
        bordercolor: supplier.isSelected.value ? AppColors.themeColor : null,
        borderRaduis: 7.r,
        shadowOpacity: 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.h,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.themeColor.withOpacity(0.06),
                          border: Border.all(
                            width: 0.6,
                            color: AppColors.themeColor,
                          ),
                        ),
                        child: Center(
                          child: TextWidget(
                            text: supplier.supplierName
                                .substring(0, 1)
                                .toUpperCase(),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            textColor: AppColors.themeColor,
                          ),
                        ),
                      ),
                      Gap.horizentalGap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: TextWidget(
                              text: supplier.supplierName.capitalizeWords,
                              textColor: AppColors.grey800,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.verticalGap(2.h),
                          Row(
                            children: [
                              TextWidget(
                                text: '+91-${supplier.supplierMobile}',
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                width: 1,
                                height: 10.h,
                                color: AppColors.grey400,
                              ),
                              TextWidget(
                                text: 'code:'.trParams({
                                  'code': supplier.milkSupplierCode,
                                }),
                                fontSize: 11.sp,
                                textColor: AppColors.grey400,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  CheckBoxWidget(isSelected: supplier.isSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAlreadyAssignedSuppliersCard(
    AssignableSupplierModel supplier,
    int index,
  ) {
    return InkWell(
      onTap: () => _assignChartToSuppliersController
          .selectSingleSuppliersToUnAssignRatechart(supplier),
      child: CommonContainer(
        containerColor: supplier.isSelected.value
            ? AppColors.themeColor.withOpacity(0.06)
            : AppColors.whiteColor,

        margin: EdgeInsets.only(top: 7.h, left: 7.w, right: 7.w),
        height: 50.h,
        borderRaduis: 7.r,

        shadowOpacity: 0.3,
        bordercolor: supplier.isSelected.value ? AppColors.themeColor : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: TextWidget(
                          text: supplier.supplierName.capitalizeWords,
                          textColor: AppColors.grey800,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${supplier.supplierMobile}',
                            fontSize: 11.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            width: 1,
                            height: 10.h,
                            color: AppColors.grey400,
                          ),
                          TextWidget(
                            text: 'code:'.trParams({
                              'code': supplier.milkSupplierCode,
                            }),
                            fontSize: 11.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CheckBoxWidget(isSelected: supplier.isSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSaveButton() {
    return InkWell(
      onTap: () =>
          _assignChartToSuppliersController.assignRateChartToSuppliers(),
      child: AppButton(
        buttonBorderRaduids: 6.r,
        buttonWidth: 70.w,

        buttonHeight: 29.h,
        title: 'save',
        buttonColor: AppColors.themeColor,
        buttonBorderColor: AppColors.themeColor,
        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: _assignChartToSuppliersController.isAssigning,
      ),
    );
  }

  _buildAppBarButton() {
    return Obx(() {
      RxBool showEnable = _assignChartToSuppliersController
          .toBeUnAssignsuppliersIds
          .isNotEmpty
          .obs;
      return InkWell(
        onTap: () =>
            _assignChartToSuppliersController.unassignRateChartToSuppliers(),
        child: AppButton(
          buttonBorderRaduids: 12.r,
          buttonWidth: 80.w,

          buttonHeight: 29.h,
          title: 'unassign',
          buttonColor: showEnable.value
              ? AppColors.redColor.withOpacity(0.8)
              : AppColors.grey200,
          buttonBorderColor: showEnable.value
              ? AppColors.redColor.withOpacity(0.8)
              : AppColors.grey200,
          shadowOpacity: 0.6,
          buttonFontWeight: FontWeight.w600,
          isLoading: false.obs,
          buttonTextColor: showEnable.value
              ? AppColors.whiteColor
              : AppColors.grey500,
          buttonFontSize: 12.sp,
        ),
      );
    });
  }

  _buildTextFormFieldForSearchMilkSupplier(
    bool isAssigned, {
    double? borderRaduis,
    double? width,
    double? height,
    double? contentPadding,
  }) {
    return Stack(
      children: [
        Container(
          width: width,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          height: height ?? 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,

            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) {
              if (isAssigned) {
                _assignChartToSuppliersController.searchAssignedSupplier(value);
              } else {
                _assignChartToSuppliersController.searchUnAssignedSupplier(
                  value,
                );
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: contentPadding ?? 16.5.h,
                horizontal: 25.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(borderRaduis ?? 30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(borderRaduis ?? 30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRaduis ?? 30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),

              hint: TextWidget(
                text: 'search_customer',
                fontSize: 10.sp,
                textColor: AppColors.grey300,
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: AppIcons.search(color: AppColors.grey300),
        ),
      ],
    );
  }
}
