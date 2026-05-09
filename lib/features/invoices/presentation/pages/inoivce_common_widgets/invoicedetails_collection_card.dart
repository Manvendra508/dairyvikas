import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/invoices/data/model/invoice_details_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

class InvoicedetailsCollectionCard extends StatelessWidget with CommonMixin {
  final List<List<InvoiceDetailsCollectionModel>> invoiceDetailsCollections;
  InvoicedetailsCollectionCard({
    super.key,
    required this.invoiceDetailsCollections,
  });
  int morningShiftKey = 1;

  int cowKey = 1;

  Widget getShiftIcon(int key) {
    return key == morningShiftKey
        ? SizedBox(width: 18, height: 18, child: AppIcons.morning())
        : SizedBox(width: 15, height: 15, child: AppIcons.evening());
  }

  Widget getMilkTypeIcon(int key) {
    return key == cowKey
        ? SizedBox(width: 17, height: 17, child: AppIcons.cow())
        : SizedBox(width: 18, height: 18, child: AppIcons.buffalo());
  }

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
                  Row(
                    children: [
                      TextWidget(
                        text: 'collections_up',
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.whiteColor,
                        fontSize: 13.sp,
                      ),
                      Gap.horizentalGap(6),
                      Container(
                        width: 70.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: AppColors.whiteColor.withOpacity(0.09),
                        ),
                        child: Center(
                          child: TextWidget(
                            text: 'shift:1/23',
                            fontWeight: FontWeight.w600,
                            fontSize: 10.6.sp,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
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
                        text: 'EDIT',
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

  _buildValueRows() {
    return Column(
      children: invoiceDetailsCollections.map((group) {
        final date = group.first.collectionDate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.verticalGap(5),

            /// 📅 Date Header
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: TextWidget(
                  text: formatDate(date), // you can format later
                  fontWeight: FontWeight.w700,

                  fontSize: 12.sp,
                  textColor: AppColors.grey700,
                ),
              ),
            ),

            /// 📦 Rows of that date
            Column(
              children: group.map((item) {
                return InkWell(
                  onTap: () {
                    AppNavigation.goToAddNewCollectionPage(false);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 2.w, right: 4.w),
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.6),
                      border: Border(
                        bottom: BorderSide(
                          width: 0.7,
                          color: AppColors.grey200,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        /// Date (day)
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: _buildDataText(
                              item.collectionDate.split('-').last,
                            ),
                          ),
                        ),

                        /// Shift + Type
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(left: 35.w),
                            child: Row(
                              children: [
                                getShiftIcon(item.shiftId), // TODO: dynamic
                                Gap.horizentalGap(12),
                                getMilkTypeIcon(
                                  item.milkTypeId,
                                ), // TODO: dynamic
                              ],
                            ),
                          ),
                        ),

                        /// Litre
                        Expanded(
                          flex: 1,
                          child: _buildDataText(
                            item.litre.toString(),
                            textColor: AppColors.grey800,
                          ),
                        ),

                        /// Fat
                        Expanded(
                          flex: 1,
                          child: _buildDataText(item.fat.toString()),
                        ),

                        /// SNF
                        Expanded(
                          flex: 1,
                          child: _buildDataText(item.snf.toString()),
                        ),

                        /// Rate
                        Expanded(
                          flex: 1,
                          child: _buildDataText('₹${item.ratePerLitre}'),
                        ),

                        /// Amount
                        Expanded(
                          flex: 1,
                          child: _buildDataText(
                            '₹${item.totalAmount}',
                            textColor: AppColors.grey800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            /// 🔥 Total per date
            _buildGroupTotal(group, date),
          ],
        );
      }).toList(),
    );
  }

  _buildGroupTotal(List<InvoiceDetailsCollectionModel> group, String date) {
    double total = group.fold(0, (sum, item) => sum + item.totalAmount);

    return Container(
      height: 30.h,
      decoration: BoxDecoration(color: AppColors.themeColor.withOpacity(0.08)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: TextWidget(
                // text:
                //     'total of ${DateFormat('dd MMM').format(DateTime.parse(date))}',
                text: 'total_of_date'.trParams({
                  "date": DateFormat('dd MMM').format(DateTime.parse(date)),
                }),
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
          // const Expanded(flex: 1, child: SizedBox()),
          // const Expanded(flex: 1, child: SizedBox()),
          // const Expanded(flex: 1, child: SizedBox()),
          // const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: _buildDataText(
                '₹${total.toStringAsFixed(1)}',
                textColor: AppColors.grey800,
                fontsize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Row(
      children: [
        Expanded(flex: 1, child: Column(children: [_buildDataText('DT')])),
        Expanded(
          flex: 2,
          child: Column(children: [_buildDataText('shift/type')]),
        ),
        Expanded(flex: 1, child: Column(children: [_buildDataText('liter')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('fat')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('snf')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('rate')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('amt')])),
      ],
    );
  }

  // _buildValueRows() {
  //   return Column(
  //     children: [
  //       Column(
  //         children: List.generate(4, (index) {
  //           return InkWell(
  //             splashColor: AppColors.transparentColor,
  //             onTap: () {
  //               AppNavigation.goToAddNewCollectionPage(false);
  //             },
  //             child: Container(
  //               margin: EdgeInsets.only(left: 2.w, right: 4.w),
  //               height: 30.h,
  //               decoration: BoxDecoration(
  //                 color: AppColors.whiteColor.withOpacity(0.6),
  //                 border: Border(
  //                   bottom: BorderSide(width: 0.7, color: AppColors.grey200),
  //                 ),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,

  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(children: [_buildDataText('01')]),
  //                       ),
  //                       Expanded(
  //                         flex: 2,
  //                         child: Padding(
  //                           padding: EdgeInsets.only(left: 17.w),
  //                           child: Row(
  //                             children: [
  //                               AppIcons.morning(),
  //                               Gap.horizentalGap(12),
  //                               // collection['data'][index]['milk_type_icon'],
  //                               AppIcons.cow(),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(
  //                           children: [
  //                             _buildDataText('L', textColor: AppColors.grey800),
  //                           ],
  //                         ),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(children: [_buildDataText('00')]),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(children: [_buildDataText('99')]),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(children: [_buildDataText('₹90')]),
  //                       ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Column(
  //                           children: [
  //                             _buildDataText(
  //                               '₹0.0',
  //                               textColor: AppColors.grey800,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //       ),
  //       _buildTotal(),
  //     ],
  //   );
  // }

  _buildTotal() {
    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.08),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildDataText('', textColor: AppColors.themeColor),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
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
                    _buildDataText('00', textColor: AppColors.themeColor),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildDataText('99', textColor: AppColors.themeColor),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildDataText('₹90', textColor: AppColors.themeColor),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildDataText('₹0.0', textColor: AppColors.grey800),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildDataText(String title, {Color? textColor, double? fontsize}) {
    return TextWidget(
      text: title.toUpperCase(),
      fontWeight: FontWeight.w600,
      fontSize: fontsize ?? 11.sp,
      textColor: textColor ?? AppColors.grey400,
    );
  }
}
