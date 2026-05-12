import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/add_collection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../core/utils/textformfield_formater.dart';
import '../../../milk_suppliers/data/model/milk_supplier_model.dart';
import 'collection_common_widgets/searched_supplier_info.dart';

class AddNewCollection extends GetView<AddNewCollectionController>
    with CommonMixin {
  final bool isfromCollectionList;
  AddNewCollection({super.key, required this.isfromCollectionList});

  final AddNewCollectionController _addNewCollectionController =
      Get.find<AddNewCollectionController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //  backgroundColor: AppColors.whiteColor,
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Visibility(
              visible: !_addNewCollectionController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairyVikasAppBar(
                    title: AppState.isCollectionEdit
                        ? 'update_collection'
                        : 'add_collection',
                    dairyName: AppState.dairyName.capitalize!,
                    trailingWidget: AppState.isCollectionEdit
                        ? _buildAppBarButton(context)
                        : null,
                  ),
                  Gap.verticalGap(6),

                  Divider(thickness: 0.2),
                  Gap.verticalGap(6),
                  _buildAddCollectionForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBarButton(BuildContext context) {
    return InkWell(
      onTap: () => _addNewCollectionController.showDeletePostOption(
        context,
        'remove_collection_message',
        isfromCollectionList,
      ),
      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 85.w,
        buttonHeight: 28.h,
        title: 'remove',
        buttonFontSize: 13.sp,
        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        buttonBorderColor: AppColors.redColor.withValues(alpha: 0.8),
        buttonColor: AppColors.redColor.withValues(alpha: 0.8),
        isLoading: _addNewCollectionController.isDeleting,
      ),
    );
  }

  _buildAddCollectionForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () =>
                        _addNewCollectionController.pickDateForFilter(context),
                    child: Container(
                      width: 1.sw / 2.3,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.whiteColor,
                        border: Border.all(
                          width: 0.5,
                          color: AppColors.themeColor,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => TextWidget(
                                text:
                                    _addNewCollectionController
                                        .selectedDateString
                                        .value
                                        .isEmpty
                                    ? 'select_date'
                                    : _addNewCollectionController
                                          .selectedDateString
                                          .value,
                                fontSize: 13.sp,
                                textColor: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AppIcons.calendar(
                              size: 15,
                              color: AppColors.grey500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildDropdownField(
                    hint: 'select_chart_shift',
                    items: AppState.shifts.sublist(0, 2),
                    selectedValue: _addNewCollectionController.selectedShift,
                  ),
                ],
              ),
              Gap.verticalGap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Container(
                          width: 0.73.sw,
                          height: 38.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 0.5,
                              color:
                                  _addNewCollectionController
                                      .isSupplierInActive
                                      .value
                                  ? AppColors.redColor.withValues(alpha: 0.8)
                                  : AppColors.themeColor,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  child: _buildTextFormFeild(
                                    _addNewCollectionController.supplierCode,
                                    'enter_supplier_code',
                                    1,
                                    TextInputType.number,
                                  ),
                                ),

                                InkWell(
                                  splashColor: AppColors.transparentColor,
                                  onTap: () => showMyBottomSheet(
                                    context,
                                    _buildSupplierList('select_suppliers'),
                                  ),
                                  child: Container(
                                    width: 65.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: AppColors.themeColor.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 9.w,
                                          vertical: 3.h,
                                        ),
                                        child: TextWidget(
                                          text: 'search',
                                          textColor: AppColors.themeColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
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

                      Gap.horizentalGap(12),
                      Container(
                        width: 60.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.whiteColor,
                          border: Border.all(
                            width: 0.5,
                            color: AppColors.themeColor,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: 'sample',
                              fontSize: 11.sp,
                              textColor: AppColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => SizedBox(
                                    width: 33.w,
                                    height: 20,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _addNewCollectionController
                                            .selectedSampleValue
                                            .value,
                                        isExpanded: true,

                                        items: _addNewCollectionController
                                            .samples
                                            .map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: TextWidget(
                                                  text: e,

                                                  textColor: AppColors.grey600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              );
                                            })
                                            .toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          _addNewCollectionController
                                                  .selectedSampleValue
                                                  .value =
                                              value;
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap.verticalGap(3),
                  GetBuilder<AddNewCollectionController>(
                    builder: (controller) => Visibility(
                      visible:
                          _addNewCollectionController.isSupplierFoundByCode &&
                          !_addNewCollectionController.isSupplierInActive.value,
                      child: SearchedSupplierInfo(
                        supplier: _addNewCollectionController.searchedSupplier,
                      ),
                    ),
                  ),
                  Gap.verticalGap(3),
                  Obx(
                    () => Visibility(
                      visible:
                          _addNewCollectionController.isSupplierInActive.value,
                      child: TextWidget(
                        text: 'is_inactive'.trParams({
                          'name': _addNewCollectionController
                              .searchedSupplier
                              .supplierName,
                        }),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.redColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              Gap.verticalGap(12),

              Obx(
                () => Row(
                  children: List.generate(
                    _addNewCollectionController.milkTypes.length,
                    (index) => _buildChartMilkTypeFilter(
                      _addNewCollectionController.milkTypes[index]['value'],
                      index,
                    ),
                  ),
                ),
              ),

              Gap.verticalGap(12),
              GetBuilder<AddNewCollectionController>(
                builder: (controller) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUnitsContainer(
                      'enter_liter',
                      context,
                      1,
                      _addNewCollectionController.literController,
                      readOnly: _addNewCollectionController.can.steps.isEmpty
                          ? false
                          : true,
                    ),
                    _buildUnitsContainer(
                      'enter_fat',
                      context,
                      2,
                      _addNewCollectionController.fatController,
                    ),
                  ],
                ),
              ),
              Gap.verticalGap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUnitsContainer(
                    'enter_snf',
                    context,
                    3,
                    _addNewCollectionController.snfController,
                  ),
                  _buildUnitsContainer(
                    'rate',
                    context,
                    4,
                    _addNewCollectionController.rateController,
                    readOnly: true,
                  ),
                ],
              ),
              Gap.verticalGap(12),
              InkWell(
                onTap: () {
                  if (_addNewCollectionController
                          .previousValueController
                          .text ==
                      '0') {
                    _addNewCollectionController.wScaleController.text =
                        _addNewCollectionController.literController.text;
                  }

                  _showAddCanBottomSheet(context);
                },
                child: AppButton(
                  title: 'add_can',
                  isLoading: false.obs,
                  shadowOpacity: 0.3,
                  borderWidth: 0.5,
                  buttonFontWeight: FontWeight.w600,
                  buttonBorderColor: AppColors.themeColor,
                  buttonColor: AppColors.whiteColor,
                  buttonTextColor: AppColors.themeColor,
                ),
              ),
              GetBuilder<AddNewCollectionController>(
                builder: (controller) => Column(
                  children: List.generate(
                    _addNewCollectionController.can.steps.length,

                    (index) => Container(
                      margin: EdgeInsets.only(top: 5.h),
                      width: 1.sw,
                      height: 25.h,
                      color: AppColors.whiteColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TextWidget(
                                  text: 'can_count'.trParams({
                                    "count":
                                        '${controller.can.steps[index].canNumber}',
                                  }),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                                Gap.horizentalGap(10.w),
                                AppIcons.longArrow(),
                                Gap.horizentalGap(10.w),
                                TextWidget(
                                  text:
                                      '${controller.can.steps[index].canLiter}L',

                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => controller.removeCanStep(index),
                              child: AppIcons.cross(
                                size: 11,
                                color: AppColors.redColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap.verticalGap(12),
              GetBuilder<AddNewCollectionController>(
                builder: (controller) => CommonContainer(
                  borderWidth: 0.5,
                  width: 1.sw,
                  shadowOpacity: 0.3,
                  borderRaduis: 8.r,
                  bordercolor: AppColors.themeColor,
                  containerColor: AppColors.whiteColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      spacing: 8.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'total_cans_added',
                              fontSize: 13.sp,
                              textColor: AppColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              text: '${controller.can.steps.length}',
                              textColor: AppColors.grey900,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'total_liter',
                              fontSize: 13.sp,
                              textColor: AppColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              text: '${controller.literController.text}L',
                              textColor: AppColors.grey900,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'total_amount',
                              fontSize: 13.sp,
                              textColor: AppColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              text: '₹${controller.getTotalAmount()}',
                              textColor: AppColors.grey900,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Gap.verticalGap(0.025.sh),
              InkWell(
                onTap: () => _addNewCollectionController.addOrUpdateCollection(
                  isfromCollectionList,
                ),
                child: AppButton(
                  title: AppState.isCollectionEdit ? 'update' : 'add',
                  isLoading: _addNewCollectionController.proccessing,
                  shadowOpacity: 0.3,
                  buttonFontSize: 15.sp,
                  buttonFontWeight: FontWeight.w600,
                ),
              ),
              Gap.verticalGap(6),
            ],
          ),
        ),
      ),
    );
  }

  _buildChartMilkTypeFilter(String title, int index) {
    RxBool isActive =
        (_addNewCollectionController.milkTypes[index]['id'] ==
                _addNewCollectionController.selectedMilkType['id'])
            .obs;
    return Obx(
      () => InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          _addNewCollectionController.selectMilkType(
            _addNewCollectionController.milkTypes[index]['id'],
          );

          _addNewCollectionController.findRateChartOfFoundSupplier();
        },
        child: Container(
          height: 25.h,
          margin: EdgeInsetsGeometry.only(
            left: index == 0 ? 0.w : 15.w,

            bottom: 10.h,
          ),
          decoration: BoxDecoration(
            color: isActive.value
                ? AppColors.themeColor.withValues(alpha: 0.7)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r),

            border: Border.all(color: AppColors.grey300, width: 0.5),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _addNewCollectionController.milkTypes[index]['icon'],
                  Gap.horizentalGap(7.w),
                  TextWidget(
                    text: title,
                    fontSize: 11.sp,
                    textColor: isActive.value
                        ? AppColors.whiteColor
                        : AppColors.grey800,
                    fontWeight: isActive.value
                        ? FontWeight.w700
                        : FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showAddCanBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blackColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: SingleChildScrollView(
                child: _buildAddCanWidget('add_can'),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildAddCanWidget(String title) {
    return Container(
      width: 1.sw,
      height: 238.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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

            Gap.verticalGap(7.h),
            Container(
              width: 1.sw,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.whiteColor,
                border: Border.all(width: 0.5, color: AppColors.grey300),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextWidget(
                          text: 'previous',
                          textColor: AppColors.grey400,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.verticalGap(20),
                        TextWidget(
                          text: _addNewCollectionController
                              .previousValueController
                              .text,
                          textColor: AppColors.grey800,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ],
                    ),
                    Container(
                      height: 50.h,
                      width: 0.7,
                      color: AppColors.grey300,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: 'w_scale',
                          textColor: AppColors.grey400,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap.verticalGap(15),
                        Container(
                          width: 80.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor.withValues(alpha: 0.4),
                          ),
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller:
                                  _addNewCollectionController.wScaleController,
                              cursorColor: AppColors.grey900,
                              cursorHeight: 16,
                              onChanged: (value) => _addNewCollectionController
                                  .calculateTempTotalValue(),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  AppRegex.onlyNumber,
                                ),
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 35.w,
                                  bottom: 8.h,
                                ),
                                border: InputBorder.none,
                                hint: TextWidget(
                                  text: '0',
                                  fontSize: 15.sp,
                                  textColor: AppColors.grey800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50.h,
                      width: 0.7,
                      color: AppColors.grey300,
                    ),
                    Obx(
                      () => Column(
                        children: [
                          TextWidget(
                            text: 'total',
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w500,
                          ),
                          Gap.verticalGap(15),
                          TextWidget(
                            text: _addNewCollectionController
                                .createTempTotalValueOfLiter
                                .value,
                            textColor: AppColors.grey800,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap.verticalGap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'can',
                  textColor: AppColors.grey400,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.sp,
                ),
                Gap.horizentalGap(0.1.sw),
                Container(
                  width: 80.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: AppColors.grey300.withValues(alpha: 0.4),
                  ),

                  child: Center(
                    child: TextWidget(
                      text: (_addNewCollectionController.can.steps.length + 1)
                          .toString(),
                      textColor: AppColors.grey800,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            Gap.verticalGap(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: AppButton(
                    buttonWidth: 1.sw / 2.2,
                    buttonHeight: 40.h,
                    title: 'cancel',
                    isLoading: false.obs,
                    shadowOpacity: 0.3,
                    borderWidth: 0.5,
                    buttonFontWeight: FontWeight.w600,

                    buttonBorderColor: AppColors.themeColor,
                    buttonColor: AppColors.whiteColor,
                    buttonTextColor: AppColors.themeColor,
                  ),
                ),

                InkWell(
                  onTap: () => _addNewCollectionController.addCanStep(),
                  child: AppButton(
                    buttonWidth: 1.sw / 2.2,
                    buttonHeight: 40.h,
                    title: 'add',
                    isLoading: false.obs,
                    shadowOpacity: 0.3,
                    borderWidth: 0.5,
                    buttonFontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFeild(
    TextEditingController controller,
    String hint,
    int id,
    TextInputType inputType,
  ) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      inputFormatters: [FilteringTextInputFormatter.allow(AppRegex.onlyNumber)],
      onChanged: (value) =>
          _addNewCollectionController.searchSupplierToAddCollectionFor(value),
      decoration: InputDecoration(
        border: InputBorder.none,
        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
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
      () => Container(
        width: 1.sw / 2.3,
        height: 40.h,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
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
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              selectedValue.value = value;
            },
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.themeColor),
          ),
        ),
      ),
    );
  }

  _buildUnitsContainer(
    String hint,
    BuildContext context,
    int id,
    TextEditingController textController, {
    bool? readOnly,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: hint,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          textColor: AppColors.grey700,
        ),
        Gap.verticalGap(5),
        Container(
          width: 1.sw / 2.2,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.whiteColor,
            border: Border.all(width: 0.5, color: AppColors.themeColor),
          ),
          child: TextFormField(
            readOnly: readOnly ?? false,
            keyboardType: TextInputType.number,
            controller: textController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) {
              if (value.length == 3 && id != 1) {
                FocusScope.of(context).nextFocus();
              }

              _addNewCollectionController.checkPriceForFatAnsSnfValue();
            },
            inputFormatters: id == 1
                ? [
                    FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                    LengthLimitingTextInputFormatter(4),
                  ]
                : [
                    FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                    OneDecimalInputFormatter(),
                  ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.w),
              border: InputBorder.none,
              hint: TextWidget(
                text: hint,
                fontSize: 12.sp,
                textColor: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSupplierList(String title) {
    return Container(
      width: 1.sw,
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withValues(alpha: 0.07),
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
            _buildTextFormFieldForSearchMilkSupplier(),

            Gap.verticalGap(7.h),

            Expanded(
              child: GetBuilder<AddNewCollectionController>(
                builder: (controller) => ListView.builder(
                  itemCount: _addNewCollectionController
                      .milkSuppliersForBottomList
                      .length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildSupplierCard(
                    _addNewCollectionController
                        .milkSuppliersForBottomList[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormFieldForSearchMilkSupplier() {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,

            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) =>
                _addNewCollectionController.searchSupplierInList(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.5.h,
                horizontal: 25.w,
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 5.w,
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(width: 0.8, color: AppColors.grey200),
              ),

              hint: TextWidget(
                text: 'search_supplier',
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

  _buildSupplierCard(MilkSupplierModel supplier) {
    return InkWell(
      onTap: () =>
          _addNewCollectionController.selectSupplierBySearching(supplier),
      child: CommonContainer(
        containerColor: AppColors.whiteColor,

        margin: EdgeInsets.only(top: 4.h, left: 0.w, right: 0.w),
        height: 45.h,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: TextWidget(
                          text: supplier.supplierName,
                          textColor: AppColors.grey800,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.verticalGap(2.h),
                      Row(
                        children: [
                          TextWidget(
                            text: '+91-${supplier.supplierMobile}',
                            fontSize: 9.sp,
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
                            text: 'code_count'.trParams({
                              'count': supplier.milkSupplierCode,
                            }),
                            fontSize: 9.sp,
                            textColor: AppColors.grey400,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
