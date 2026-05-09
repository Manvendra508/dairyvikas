import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/common_container.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/core/utils/gap.dart';
import 'package:DairyVikas/features/collection/data/model/collection_model.dart';
import 'package:DairyVikas/features/collection/presentation/controllers/add_collection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/model/collection_can_model.dart';

class Collectionadjustmentcard extends StatelessWidget {
  final Map collection;
  final String supplierCode;
  final String collectionDate;
  Collectionadjustmentcard({
    super.key,
    required this.collection,
    required this.supplierCode,
    required this.collectionDate,
  });

  CollectionModel collectionModel = CollectionModel.empty();

  convertRowCollectionIntoModel(var collectionJson) {
    Get.delete<
      AddNewCollectionController
    >(); // this will call init method of add collection controller
    //otherwise the init method will not called.
    if (collectionJson['id'].toString().isEmpty) {
      collectionModel.collectionDate = collectionDate;
      collectionModel.collectionSupplier = CollectionSupplierModel(
        supplierName: '',
        milkSupplierCode: supplierCode,
      );
      // This is the case where collection is empty.
    } else {
      collectionModel = CollectionModel(
        collectionId: collectionJson['id'],
        supplierId: collectionJson['supplier_id'],
        collectionShiftId: collectionJson['shift_id'],
        milkTypeId: collectionJson['milk_type_id'],
        litre: collectionJson['ltr'],
        fat: double.parse(collectionJson['fat'].toString()),
        snf: double.parse(collectionJson['snf'].toString()),
        clr: double.parse(collectionJson['clr'].toString()),
        ratePerLitre: collectionJson['rate_per_litre'],
        totalAmount: double.parse(collectionJson['total_amount'].toString()),
        collectionDate: collectionJson['collection_date'],
        collectionSupplier: CollectionSupplierModel(
          supplierName: '',
          milkSupplierCode: supplierCode,
        ), // we are sending only supplier code the remaining data will fetch on
        //the basis of code in add collection controller.
        steps: List<CanStepModel>.from(
          collectionJson['can_data'].map((cs) => CanStepModel.fromJson(cs)),
        ),
        sampleCount: collectionJson['sample_count'],
      );
    }
    AppState.isCollectionEdit = true;
    AppState.currentCollectionforUpdate = collectionModel;
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      width: 1.sw,
      margin: EdgeInsets.only(left: 6.w, right: 6.w, top: 8.h),
      // height: 150.h,
      borderRaduis: 12.r,
      containerColor: AppColors.whiteColor,
      shadowOpacity: 0.3,
      bordercolor: AppColors.grey300,

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
              color: AppColors.grey100,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: '${collection['date']}',
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                  Container(
                    width: 70.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: AppColors.greenColor.withOpacity(0.2),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: '₹${collection['total_amount']}',
                        fontWeight: FontWeight.w600,
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
          flex: 2,
          child: Column(children: [_buildDataText('shift/type')]),
        ),
        Expanded(flex: 1, child: Column(children: [_buildDataText('liter')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('fat')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('snf')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('clr')])),
        Expanded(flex: 1, child: Column(children: [_buildDataText('rate')])),
      ],
    );
  }

  _buildValueRows() {
    return Column(
      children: List.generate(collection['data'].length, (index) {
        return InkWell(
          splashColor: AppColors.transparentColor,
          onTap: () {
            convertRowCollectionIntoModel(collection['data'][index]);
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
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 17.w),
                        child: Row(
                          children: [
                            collection['data'][index]['shift_icon'],

                            Gap.horizentalGap(16),
                            collection['data'][index]['milk_type_icon'],
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDataText(
                            '${collection['data'][index]['ltr']}${collection['data'][index]['ltr'] == '-' ? '' : "L"}',
                            textColor: AppColors.grey800,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDataText('${collection['data'][index]['fat']}'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDataText('${collection['data'][index]['snf']}'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDataText('${collection['data'][index]['clr']}'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildDataText(
                            collection['data'][index]['rate'] == '-'
                                ? '₹0.0'
                                : '₹${collection['data'][index]['rate']}.0',
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
    );
  }

  _buildDataText(String title, {Color? textColor}) {
    return TextWidget(
      text: title.toUpperCase(),
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
      textColor: textColor ?? AppColors.grey400,
    );
  }
}
