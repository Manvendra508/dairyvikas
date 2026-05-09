import 'package:DairyVikas/app/extensions/string_ext.dart';
import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/collection/data/model/collection_model.dart';
import 'package:DairyVikas/features/invoices/data/model/invoice_details_item_sale_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CattelFeedCard extends StatelessWidget {
  final List<InvoiceDetailsItemSaleModel> invoiceDetailsItemSales;
  CattelFeedCard({super.key, required this.invoiceDetailsItemSales});

  CollectionModel collectionModel = CollectionModel.empty();

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 1.sw,
      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 8.h),

      borderRaduis: 12.r,
      containerColor: AppColors.whiteColor,
      shadowOpacity: 0.4,
      bordercolor: AppColors.grey200,

      child: Column(
        children: [
          Container(
            height: 33.h,
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              color: AppColors.themeColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'food_or_item',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    textColor: AppColors.whiteColor,
                  ),
                  Container(
                    width: 70.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: AppColors.whiteColor,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'edit_up',
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        textColor: AppColors.themeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColors.grey100.withOpacity(0.6),
              border: Border(
                bottom: BorderSide(width: 0.7, color: AppColors.grey200),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 9.w),

              child: _buildHeader(),
            ),
          ),

          _buildValueRows(),
        ],
      ),
    );
  }

  _buildHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(right: 40.w),
            child: Column(children: [_buildDataText('product_name_up')]),
          ),
        ),

        Expanded(flex: 1, child: Column(children: [_buildDataText('qty')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('rate')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('amt')])),
      ],
    );
  }

  _buildValueRows() {
    return Column(
      children: [
        Column(
          children: List.generate(invoiceDetailsItemSales.length, (index) {
            return InkWell(
              splashColor: AppColors.transparentColor,
              onTap: () {
                AppNavigation.goToAddNewCollectionPage(false);
              },
              child: Container(
                margin: EdgeInsets.only(left: 2.w, right: 4.w),
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withOpacity(0.6),
                  border: Border(
                    bottom: BorderSide(width: 0.7, color: AppColors.grey200),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.w),
                            child: TextWidget(
                              text: invoiceDetailsItemSales[index]
                                  .itemName
                                  .capitalize,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                              textColor: AppColors.grey800,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildDataText(
                                invoiceDetailsItemSales[index].quantity
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildDataText(
                                '₹${invoiceDetailsItemSales[index].sellingPrice}',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildDataText(
                                '₹${invoiceDetailsItemSales[index].totalAmount}',
                                textColor: AppColors.grey800,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        _buildTotal(invoiceDetailsItemSales),
      ],
    );
  }

  _buildTotal(List<InvoiceDetailsItemSaleModel> invoiceDetailsItemSales) {
    double total = invoiceDetailsItemSales.fold(
      0,
      (sum, item) => sum + item.totalAmount,
    );

    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 17.w),
                    child: TextWidget(
                      text: 'TOTAL',
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                      textColor: AppColors.grey900,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildDataText('L', textColor: AppColors.themeColor),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildDataText('', textColor: AppColors.themeColor),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildDataText(
                        '₹${total.toStringAsFixed(1)}',
                        textColor: AppColors.grey800,
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildDataText(String title, {Color? textColor, double? fontSize}) {
    return TextWidget(
      text: title,
      fontWeight: FontWeight.w600,
      fontSize: fontSize ?? 11.sp,
      textColor: textColor ?? AppColors.grey400,
    );
  }
}
