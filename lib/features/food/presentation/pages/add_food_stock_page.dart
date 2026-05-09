import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_bar.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/app_regex.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/food/presentation/food_comon_widgets/search_dealer_info.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_widget/app_loader.dart';
import '../../../../common/common_widget/message_box.dart';
import '../../../../core/utils/app_icons.dart';
import '../controllers/add_food_stock_controller.dart'
    show AddFoodStockController;
import '../food_comon_widgets/dealer_list_bottomsheet.dart';

class AddFoodStockPage extends GetView<AddFoodStockController>
    with CommonMixin {
  bool isFromStockListing;
  AddFoodStockPage({super.key, required this.isFromStockListing});

  final AddFoodStockController _addFoodStockController =
      Get.find<AddFoodStockController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.whiteColor,
        body: Obx(
          () => Visibility(
            visible: !_addFoodStockController.isLoading.value,
            replacement: DairyVikasLoader(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.verticalGap(10),

                  DairyVikasAppBar(
                    title: AppState.isFoodStockEdit
                        ? 'update_stock'
                        : 'add_stock',
                    dairyName: AppState.dairyName.capitalize!,
                  ),
                  Gap.verticalGap(6),

                  Divider(thickness: 0.2),
                  Gap.verticalGap(6),
                  _buildFoodAddFoodStockForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFoodAddFoodStockForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Obx(
                () => MessageBox(
                  message: _addFoodStockController.validationErrorMessage,
                  isVisible: _addFoodStockController.hasFieldError.value,
                  isError: true,
                ),
              ),
              InkWell(
                onTap: () => _addFoodStockController.pickDateForFilter(context),
                child: Container(
                  width: 1.sw,
                  height: 38.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.whiteColor,
                    border: Border.all(width: 0.5, color: AppColors.themeColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => TextWidget(
                            text:
                                _addFoodStockController
                                    .selectedDateString
                                    .value
                                    .isEmpty
                                ? 'select_date'
                                : _addFoodStockController
                                      .selectedDateString
                                      .value,
                            fontSize: 13.sp,
                            textColor: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AppIcons.calendar(size: 15, color: AppColors.grey500),
                      ],
                    ),
                  ),
                ),
              ),

              Gap.verticalGap(10),
              _buildDealerSearchByCode(context),
              Gap.verticalGap(10),

              _buildTextFormFeild(
                _addFoodStockController.foodName,
                'select_items_to_add',
                1,
                TextInputType.text,
                true,
                context,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodStockController.foodQuantity,
                'enter_food_qty',
                2,
                TextInputType.number,
                false,
                context,
              ),

              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodStockController.foodBuyRate,
                'enter_buy_rate',
                3,
                TextInputType.number,
                false,
                context,
              ),
              Gap.verticalGap(10),
              _buildTextFormFeild(
                _addFoodStockController.foodSaleRate,
                'enter_sale_rate',
                4,
                TextInputType.number,
                false,
                context,
              ),

              Gap.verticalGap(10),
              _buildUnitDropDown(context),
              // _buildTextFormFeild(
              //   _addFoodStockController.foodAmountPaid,
              //   'amount_paid',
              //   5,
              //   TextInputType.number,
              //   false,
              //   context,
              // ),
              Gap.verticalGap(25),
              InkWell(
                onTap: () {
                  if (AppState.isFoodStockEdit) {
                    _addFoodStockController.updateStock();
                  } else {
                    _addFoodStockController.addStock(isFromStockListing);
                  }
                },
                child: AppButton(
                  title: AppState.isFoodStockEdit ? 'update' : 'add',
                  buttonFontWeight: FontWeight.w600,
                  isLoading: _addFoodStockController.proccessing,
                  shadowOpacity: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildUnitDropDown(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 40.h,
      child: DropdownSearch<String>(
        key: _addFoodStockController.dropDownKey,
        selectedItem: "unit",
        items: (filter, infiniteScrollProps) => [
          "Apple",
          "Orange",
          "Chiku",
          "Dates",
          "PUppy",
          'Hey',
          'Waire',
          'dog',
          'cat',
          'my',
          'lion',
          'cow',
          'buffalo',
        ],

        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(width: 0.8, color: AppColors.lightBorder),
            ),
          ),
        ),

        suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
            isVisible: true,
            iconOpened: AppIcons.arrowUp(),
            iconClosed: AppIcons.arrowDown(),
          ),
        ),
        popupProps: PopupProps.menu(
          containerBuilder: (context, popupWidget) {
            return SafeArea(child: popupWidget);
          },
          scrollbarProps: ScrollbarProps(
            trackColor: AppColors.grey300,
            thumbColor: AppColors.themeColor,
            thickness: 4,
            trackVisibility: true,
            radius: Radius.circular(20),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              fillColor: AppColors.whiteColor,
              filled: true,
              hint: TextWidget(
                text: 'search_unit',
                textColor: AppColors.grey300,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  width: 0.8,
                  color: AppColors.lightBorder,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
          fit: FlexFit.loose,
          showSearchBox: true,
          searchDelay: Duration(milliseconds: 200),
          constraints: BoxConstraints(),
        ),
      ),
    );
  }

  _buildTextFormFeild(
    TextEditingController controller,
    String hint,
    int id,
    TextInputType inputType,
    bool? readOnly,
    BuildContext context,
  ) {
    return TextFormField(
      onTap: (id == 1 && !AppState.isFoodStockEdit)
          ? () async {
              if (AppState.currentStockItem.stockId == 0) {
                final result =
                    await AppNavigation.goToItemListPage<
                      Map<String, dynamic>
                    >();
                if (result == null) return;
                _addFoodStockController.foodName.text = result['name'];
                _addFoodStockController.foodId = result['id'];
              }
            }
          : null,
      keyboardType: inputType,
      controller: controller,
      cursorColor: AppColors.grey500,
      cursorHeight: 20,

      readOnly: readOnly ?? false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(AppRegex.onlyNumber),

        LengthLimitingTextInputFormatter(id == 1 ? 35 : 10),
      ],
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
        suffixIcon: id == 1 && !AppState.isFoodStockEdit
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                height: 20.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.grey500.withOpacity(0.1),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 3.h,
                    ),
                    child: TextWidget(
                      text: 'select_food',
                      textColor: AppColors.grey700,

                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),

        hint: TextWidget(
          text: hint,
          fontSize: 12.sp,
          textColor: AppColors.textLight,
        ),
      ),
    );
  }

  _buildDealerSearchByCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1.sw,
          height: 38.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.whiteColor,
            border: Border.all(width: 0.5, color: AppColors.themeColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150.w,
                  child: TextFormField(
                    readOnly: AppState.isFoodStockEdit,
                    keyboardType: TextInputType.number,
                    controller: _addFoodStockController.dealerCode,
                    cursorColor: AppColors.grey500,
                    cursorHeight: 20,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(AppRegex.onlyNumber),
                    ],
                    onChanged: (value) => _addFoodStockController
                        .searchDealerToAddFoodStockOf(value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hint: TextWidget(
                        text: 'dealer_code',
                        fontSize: 12.sp,
                        textColor: AppColors.textLight,
                      ),
                    ),
                  ),
                ),

                AppState.isFoodStockEdit
                    ? SizedBox.shrink()
                    : InkWell(
                        splashColor: AppColors.transparentColor,
                        onTap: () => showMyBottomSheet(
                          context,
                          DealerListBottomSheet(
                            title: 'select_dealer',
                            searchDealerInList:
                                _addFoodStockController.searchDealerInList,
                            selectDealerBySearching: _addFoodStockController
                                .selectDealerBySearchingInList,
                          ),
                        ),
                        child: Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.themeColor.withOpacity(0.1),
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

        Gap.verticalGap(3),
        GetBuilder<AddFoodStockController>(
          builder: (controller) => Visibility(
            visible: _addFoodStockController.isDealerFoundByCode.value,
            child: SearchDealerInfo(
              dealer: _addFoodStockController.searchedDealer,
            ),
          ),
        ),
      ],
    );
  }
}
