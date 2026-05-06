import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/text_widget.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/utils/app_navigation.dart';
import '../../data/models/sale_model.dart';
import '../../domain/usecases/get_food_sales_usecase.dart';

class FoodSalesController extends GetxController with CommonMixin {
  final GetFoodSalesUsecase _foodSalesUsecase;

  RxBool hasError = false.obs;
  RxInt currentDateFilterIndex = 0.obs;
  RxList<SaleModel> sales = <SaleModel>[].obs;
  RxList dateRanges = [].obs;

  RxInt currentDateRangeIndex = 0.obs;
  RxBool isLoading = false.obs;
  List<SaleModel> filteredSales = <SaleModel>[];
  DateTime now = DateTime.now();
  RxString selectedDateFilter = '0'.obs;
  String startDate = '';
  String endDate = '';
  RxList<Map<String, dynamic>> dateFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'today'},
    {"id": '1', "title": 'this_week'},
    {"id": '2', "title": 'this_month'},
    {"id": '3', "title": 'last_month'},
    {"id": '4', "title": 'custom'},
  ].obs;

  FoodSalesController(this._foodSalesUsecase);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    startDate = formatDateforApi(now);
    endDate = formatDateforApi(now);
    await getFoodtSales();
  }

  selectDateFilter(int index, BuildContext context) async {
    currentDateFilterIndex.value = index;
    selectedDateFilter.value = dateFilters[index]['id'];

    if (dateFilters[index]['id'] == '4') {
      DateRange? range = await pickDateRange(
        context: context,
        maxDate: DateTime.now(),
      );
      if (range != null) {
        startDate = formatDateforApi(range.startDate);
        endDate = formatDateforApi(range.endDate);
        await getFoodtSales();
      }
    } else {
      final range = getDateRangeByFilter(
        filterId: dateFilters[index]['id'],
        customStartDate: null,
        customEndDate: null,
      );

      startDate = formatDateforApi(range.startDate);
      endDate = formatDateforApi(range.endDate);
      await getFoodtSales();
    }
  }

  Future getFoodtSales() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';

      final saleData = {
        "dairy_id": dairyId,
        "start_date": startDate,
        "end_date": endDate,
        "limit": 100,
      };

      Map response = await _foodSalesUsecase(saleData);

      if (response['success']) {
        hasError.value = false;
        sales.clear();

        List salesJson = response['data']['sales'] as List;

        sales.assignAll(
          salesJson.map((item) => SaleModel.fromJson(item)).toList(),
        );
        filteredSales.assignAll(sales);
      } else {
        hasError.value = true;
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);

      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  selectDateRange(int index) async {
    currentDateRangeIndex.value = index;

    AppNavigation.goBack();
  }

  DateRange getDateRangeByFilter({
    required String filterId,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    final now = DateTime.now();

    switch (filterId) {
      /// TODAY
      case '0':
        return DateRange(
          startDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
        );

      /// THIS WEEK (Mon → Sun)
      case '1':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return DateRange(
          startDate: DateTime(
            startOfWeek.year,
            startOfWeek.month,
            startOfWeek.day,
            0,
            0,
            0,
          ),
          endDate: DateTime(
            endOfWeek.year,
            endOfWeek.month,
            endOfWeek.day,
            23,
            59,
            59,
          ),
        );

      /// THIS MONTH
      case '2':
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return DateRange(
          startDate: DateTime(
            startOfMonth.year,
            startOfMonth.month,
            1,
            0,
            0,
            0,
          ),
          endDate: DateTime(
            endOfMonth.year,
            endOfMonth.month,
            endOfMonth.day,
            23,
            59,
            59,
          ),
        );

      /// LAST MONTH 👇
      case '3':
        final firstDayOfThisMonth = DateTime(now.year, now.month, 1);
        final startOfLastMonth = DateTime(
          firstDayOfThisMonth.year,
          firstDayOfThisMonth.month - 1,
          1,
        );
        final endOfLastMonth = DateTime(
          firstDayOfThisMonth.year,
          firstDayOfThisMonth.month,
          0,
        );

        return DateRange(
          startDate: DateTime(
            startOfLastMonth.year,
            startOfLastMonth.month,
            startOfLastMonth.day,
            0,
            0,
            0,
          ),
          endDate: DateTime(
            endOfLastMonth.year,
            endOfLastMonth.month,
            endOfLastMonth.day,
            23,
            59,
            59,
          ),
        );

      /// CUSTOM
      case '4':
        if (customStartDate == null || customEndDate == null) {
          throw Exception('Custom date range required');
        }
        return DateRange(startDate: customStartDate, endDate: customEndDate);

      default:
        throw Exception('Invalid filter');
    }
  }

  Future<DateRange?> pickDateRange({
    required BuildContext context,
    DateTime? minDate,
    DateTime? maxDate,
  }) async {
    PickerDateRange? selectedRange;

    return await showDialog<DateRange>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          iconColor: AppColors.themeColor,

          title: TextWidget(
            text: 'select_date_range',
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 350.h,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: minDate,
              maxDate: maxDate,
              onSelectionChanged: (args) {
                if (args.value is PickerDateRange) {
                  selectedRange = args.value;
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextWidget(
                text: 'cancel',
                fontWeight: FontWeight.w600,
                textColor: AppColors.blackColor,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.themeColor),
              ),
              onPressed: () {
                if (selectedRange == null ||
                    selectedRange!.startDate == null ||
                    selectedRange!.endDate == null) {
                  showAppToastMessage('select_valid_date_range', true);
                  return;
                }

                final start = selectedRange!.startDate!;
                final end = selectedRange!.endDate!;

                Navigator.pop(
                  context,
                  DateRange(
                    startDate: DateTime(
                      start.year,
                      start.month,
                      start.day,
                      0,
                      0,
                      0,
                    ),
                    endDate: DateTime(end.year, end.month, end.day, 23, 59, 59),
                  ),
                );
              },
              child: TextWidget(
                text: 'done',
                fontWeight: FontWeight.w500,
                textColor: AppColors.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});
}
