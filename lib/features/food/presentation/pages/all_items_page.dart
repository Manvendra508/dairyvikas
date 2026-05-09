import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/food/data/models/item_model.dart';
import 'package:DairyVikas/features/food/presentation/controllers/get_all_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/retry_widget.dart';

class AllItemsPage extends GetView<AllItemsController> with CommonMixin {
  AllItemsPage({super.key});

  final AllItemsController _allItemsController = Get.find<AllItemsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Obx(
            () => Visibility(
              visible: !_allItemsController.isLoading.value,
              replacement: DairyVikasLoader(),
              child: Visibility(
                visible: !_allItemsController.hasError.value,
                replacement: RetryWidget(
                  onRetry: () => _allItemsController.getAllItems(),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.verticalGap(10),

                    DairyVikasAppBar(
                      title: 'all_items',
                      dairyName: AppState.dairyName.capitalize!,

                      trailingWidget: _buildAppBarButton(context),
                    ),
                    Gap.verticalGap(6),
                    Divider(thickness: 0.2),

                    Gap.verticalGap(10),

                    _buildTextFormFieldForSearchItems(),
                    Gap.verticalGap(10),

                    Expanded(
                      child: GetBuilder<AllItemsController>(
                        builder: (controller) {
                          return Visibility(
                            visible:
                                _allItemsController.filteredItems.isNotEmpty,
                            replacement: _buildNotFoundWidget(),

                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  _allItemsController.filteredItems.length,
                              itemBuilder: (context, index) {
                                return _buildItemWidget(
                                  index,
                                  _allItemsController.filteredItems[index],
                                  context,
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

  _buildNotFoundWidget() {
    return Center(
      child: Column(
        children: [
          Gap.verticalGap(0.2.sh),
          TextWidget(
            text: 'no_item_available',
            fontSize: 14.sp,
            textColor: AppColors.grey600,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          Gap.verticalGap(10),
          InkWell(
            onTap: () => AppNavigation.goToAddDealerPage(),
            child: AppButton(
              buttonWidth: 100.w,
              buttonHeight: 30.h,
              shadowOpacity: 0.6,
              buttonBorderRaduids: 6.r,
              title: 'add_now',
              buttonFontWeight: FontWeight.w600,
              buttonFontSize: 12.sp,
              isLoading: false.obs,
            ),
          ),
        ],
      ),
    );
  }

  _buildTextFormFieldForSearchItems() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          height: 35.h,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: _allItemsController.searchController,
            cursorColor: AppColors.grey500,
            cursorHeight: 20,
            onChanged: (value) => _allItemsController.searchItem(value),
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
                text: 'search_item',
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

  _buildItemWidget(int index, ItemModel item, BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigation.goBack({"name": item.itemName, "id": item.id});
      },
      child: Container(
        width: 1.sw,

        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(2.r),
          border: Border(
            bottom: BorderSide(color: AppColors.grey200, width: 0.7),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(
                left: 14.w,
                right: 25.w,
                bottom: 12.h,
                top: 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36.h,
                        height: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.themeColor.withOpacity(0.06),
                          border: Border.all(
                            width: 0.6,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        child: Center(
                          // child: TextWidget(
                          //   text: item.itemName.substring(0, 1).toUpperCase(),

                          //   fontWeight: FontWeight.w600,
                          //   fontSize: 16.sp,
                          //   textColor: AppColors.themeColor,
                          // ),
                          child: AppIcons.stock(
                            size: 20,
                            color: AppColors.themeColor,
                          ),
                        ),
                      ),

                      Gap.horizentalGap(0.02.sw),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            child: TextWidget(
                              text: item.itemName.capitalize!,
                              textColor: AppColors.grey800,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap.verticalGap(2.h),
                          Row(
                            children: [
                              TextWidget(
                                text: 'added_by',
                                fontSize: 10.sp,
                                textColor: AppColors.grey400,

                                fontWeight: FontWeight.w600,
                              ),
                              Gap.horizentalGap(5),
                              TextWidget(
                                text: item.createdByVendorId == null
                                    ? 'DairyVikas'
                                    : 'added_by_you',
                                fontSize: 10.sp,
                                textColor: AppColors.grey600,

                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: item.createdByVendorId != null,
                    child: InkWell(
                      onTap: () {
                        _allItemsController.itemNameController.text =
                            item.itemName;
                        showAddItemBottomSheet(
                          context,
                          _buildAddItemSheetWidget(
                            'edit_your_item',
                            true,
                            context,
                            item,
                          ),
                        );
                      },
                      child: Container(
                        width: 36.h,
                        height: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.whiteColor.withOpacity(0.06),
                          border: Border.all(
                            width: 0.6,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        child: Center(
                          child: AppIcons.edit(
                            size: 16,
                            color: AppColors.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBarButton(BuildContext context) {
    return InkWell(
      onTap: () => showAddItemBottomSheet(
        context,
        _buildAddItemSheetWidget('add_your_item', false, context, null),
      ),

      child: AppButton(
        buttonBorderRaduids: 20.r,
        buttonWidth: 80.w,
        buttonHeight: 27.h,
        buttonFontSize: 12.sp,
        title: 'add_item',

        shadowOpacity: 0.6,
        buttonFontWeight: FontWeight.w600,
        isLoading: false.obs,
      ),
    );
  }

  void showAddItemBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  _buildAddItemSheetWidget(
    String title,
    bool isUpdate,
    BuildContext context,
    ItemModel? item,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: 1.sw,
          height: 0.25.sh,
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
                _buildTextFormFeild(),
                Gap.verticalGap(17.h),
                InkWell(
                  onTap: () {
                    if (isUpdate) {
                      if (item == null) return;
                      _allItemsController.updateItem(item.itemName, item.id);
                    } else {
                      _allItemsController.addNewItem();
                    }
                  },
                  child: AppButton(
                    title: isUpdate ? 'update' : 'add',
                    buttonFontWeight: FontWeight.w600,
                    isLoading: _allItemsController.proccessing,
                    shadowOpacity: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextFormFeild() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _allItemsController.itemNameController,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      inputFormatters: [LengthLimitingTextInputFormatter(35)],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.5.h, horizontal: 7.w),
        focusedBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 5.w,
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
        ),

        hint: TextWidget(
          text: 'enter_your_item_name',
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }
}
