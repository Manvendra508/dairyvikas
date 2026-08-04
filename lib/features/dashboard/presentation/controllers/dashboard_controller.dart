// lib/presentation/controllers/auth/login_controller.dart
import 'dart:async';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/choose_photo_widget.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:DairyVikas/features/dashboard/data/model/dashbaord_response_model.dart';
import 'package:DairyVikas/features/dashboard/domain/usecases/fetch_dashboard_data_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/common_controller.dart';
import '../../../../common/common_widget/free_trial_end_widget.dart';

class DashboardController extends GetxController with CommonMixin {
  RxBool hasThought = true.obs;
  bool hasprofilephoto = true;
  RxBool hasError = false.obs;
  final FetchDashboardDataUsecase fetchDashboardDataUsecase;
  RxBool isLoading = false.obs;
  Rx<DashbaordResponseModel> dashboardData = DashbaordResponseModel.empty().obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxDouble progress = 0.0.obs;
  String languageCode = 'en';
  String vendorDistrict = 'unknown';
  String vendorState = 'unknown';

  DashboardController(this.fetchDashboardDataUsecase);

  @override
  void onInit() {
    if (hasThought.value) {
      startProgress();
    }

    firstMethod();
    super.onInit();
  }

  firstMethod() async {
    final commonController = Get.find<CommonController>();
    languageCode = getLocal();
    String dairyId = await SharedPrefsService.instance.getDairyId() ?? '0';
    AppState.isDairyAdded = dairyId != '0';

    await fetchDashBoardData();
    await commonController.getDateRange();
    await commonController
        .getAllMilkSuppliers(); // This will fetch all suppliers And Aggin them in
    // global list in appstate. from where we can use them in entire app.so we dont need to fetch them again and again.

    await commonController.fetchDairySettingsData();
  }

  pressAgainToExit(DateTime? lastBackPressed) {
    final now = DateTime.now();

    // ignore: unnecessary_null_comparison
    if (lastBackPressed == null ||
        now.difference(lastBackPressed) > const Duration(seconds: 2)) {
      lastBackPressed = now;

      showAppToastMessage('press_again_to_exit', false);

      return false;
    }
  }

  openDrawer() {
    if (scaffoldKey.currentState == null) return;
    scaffoldKey.currentState!.openDrawer();
  }

  navigateToScreen(String id) {
    switch (id) {
      case '1':
        AppNavigation.goToAllCollectionsPage();
        break;
      case '2':
        AppNavigation.goToFoodSalesPage();

        break;
      case '3':
        AppNavigation.goToAllMilkSalePage();
        break;
      case '4':
        //  AppNavigation.goToDairyCenterDetailsPage();
        break;
      case '5':
        AppNavigation.goToAllMilkSuppliersPage();
        break;
      case '6':
        AppNavigation.goToAllHisaabPage();
        break;
      case '7':
        AppNavigation.goToAllInvoicesPage();
        break;
      case '8':
        AppNavigation.goToAllRateChartsPage();

      case '9':
      //  AppNavigation.goToDairyCenterDetailsPage();
      case '10':
        AppNavigation.goToNoticePostsPage();

        break;
      default:
    }
  }

  void startProgress() {
    progress.value = 0.0;

    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (progress.value >= 1.0) {
        progress.value = 1.0;
        timer.cancel();
      } else {
        progress.value += 0.01;
      }
    });
  }

  Future<void> fetchDashBoardData() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      String dairyId = await SharedPrefsService.instance.getDairyId() ?? '';

      dashboardData.value = await fetchDashboardDataUsecase(dairyId);
      if (dashboardData.value.success) {
        hasError.value = false;

        bool hasdairyData =
            dashboardData.value.dashboardDataModel.dairy != null &&
            dashboardData.value.dashboardDataModel.dairy!.state.isNotEmpty;
        if (hasdairyData) {
          getVendorStateAndDistrict(
            dashboardData.value.dashboardDataModel.dairy!,
          );
        }
        isLoading.value = false;
      } else {
        // hasError.value = true;
        showAppToastMessage(dashboardData.value.message, true);
      }
    } catch (e) {
      // hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isLoading.value = false;
    }
  }

  getVendorStateAndDistrict(DairyModel dairy) {
    AppState.dairyName = dairy.dairyName;
    AppState.vendorName.value = dairy.vendorName;

    Map<String, dynamic> state = AppState.indianStates.firstWhere(
      (state) => state['id'] == int.parse(dairy.state),
    );

    vendorState = languageCode == 'en' || languageCode == ''
        ? state['name_en']
        : state['name_hi'];
    AppState.vendorState = vendorState;
    Map<String, dynamic> district = state['districs'].firstWhere(
      (district) => district['id'] == int.parse(dairy.district),
    );
    vendorDistrict = languageCode == 'en' || languageCode == ''
        ? district['name_en']
        : district['name_hi'];

    AppState.vendorDistrict = vendorDistrict;
  }

  showDialogForImage(BuildContext context) {
    showDialogBox(
      context: context,
      child: ChoosePhotoWidget(),
      title: 'choose_photo',
    );
  }

  showDialogForExpireFreeTrial(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(25.r),
          ),

          content: FreeTrialEndWidget(languageCode: languageCode),
        );
      },
    );
  }

  showBottomStoryOrPhotoBottomsheet(BuildContext context, Widget child) {
    showMyBottomSheet(context, child);
  }

  showDeairyDetailsAddBottomsheet(BuildContext context, Widget child) {
    showMyBottomSheet(context, child);
  }

  addThoughtOrProfilePhoto(int id, BuildContext context) {
    AppNavigation.goBack();
    if (id == 1) {
      if (hasThought.value) {
        // run view thought function

        showThoughtBottomSheet(context);
      } else {
        showDialogForImage(context);
      }
    } else if (id == 2) {
      showDialogForImage(context);
    } else if (id == 3) {
      // run function for remove thought
    } else {
      // run function for text thought
    }
  }
}
