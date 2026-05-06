import 'dart:async';

import 'package:dairysathi/app/theme/app_colors.dart';
import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/common/common_widget/language_selector.dart';
import 'package:dairysathi/common/common_widget/select_bool_option_widget.dart';
import 'package:dairysathi/core/error/exceptions.dart';
import 'package:dairysathi/core/local_datasources/app_state.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/local_datasources/secured_storage_service.dart';
import 'package:dairysathi/core/other_services/auth_service.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/core/utils/assets_paths.dart';
import 'package:dairysathi/features/profile_and_settings/data/model/curent_plan_model.dart';
import 'package:dairysathi/features/profile_and_settings/domain/usecases/get_current_plan_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/usecases/update_dairy_name_usecase.dart';

class ProfileController extends GetxController
    with CommonMixin, GetSingleTickerProviderStateMixin {
  final GetCurrentPlanUsecase getCurrentPlanUsecase;
  final UpdateVendorNameUsecase updateVendorNameUsecase;
  RxBool isScanning = false.obs;
  late AnimationController animationController;
  final nameController = TextEditingController();
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  late Animation<double> animation;
  RxBool isUpdatingName = false.obs;
  RxBool isDeleteProcessed = false.obs;
  CurrentPlanModel currentPlan = CurrentPlanModel.empty();
  RxBool isDeleting = false.obs;
  RxBool showplanBox = false.obs;
  RxDouble progress = 0.0.obs;
  RxDouble subscriptionProgressLine = 0.0.obs;
  final dio = Dio();
  final authSerive = AuthService();
  List deivces = [];

  ProfileController({
    required this.updateVendorNameUsecase,
    required this.getCurrentPlanUsecase,
  });

  List profileData = [
    // {
    //   'id': "1",
    //   "title": "Credits",
    //   "dec": "You have ₹200 credits",
    //   "showArrow": false,
    //   "icon": AssetsPaths.creditsIcon,
    //   "color": AppColors.grey700,
    //   "show": true,
    // },

    // {
    //   'id': "2",
    //   "title": "Refer & Earn",
    //   "dec": "Refer friends and earn rewards",
    //   "showArrow": true,
    //   "icon": AssetsPaths.referIcon,
    //   "color": AppColors.grey700,
    //   "show": true,
    // },
    {
      'id': "3",
      "title": "Transaction History",
      "dec": "See your transaction history",
      "showArrow": true,
      "icon": AssetsPaths.transaction,
      "color": AppColors.grey700,
      "show": true,
    },
    {
      'id': "4",
      "title": "Dairy & Other Settings",
      "dec": "Manage your dairy and other settings",
      "showArrow": true,
      "icon": AssetsPaths.setting,
      "color": AppColors.grey700,
      "show": true,
    },
    {
      'id': "5",
      "title": "Change Language",
      "dec": "Manage your passwords",
      "showArrow": true,
      "icon": AssetsPaths.changeLanguage,
      "color": AppColors.grey700,
      "show": true,
    },
    {
      'id': "6",
      "title": "Help & Support",
      "dec": "Get help and support",
      "showArrow": true,
      "icon": AssetsPaths.help,
      "color": AppColors.grey700,
      "show": true,
    },
    {
      'id': "7",
      "title": "About Us",
      "dec": "Learn more about us",
      "showArrow": true,
      "icon": AssetsPaths.about,
      "color": AppColors.grey700,
      "show": true,
    },

    {
      'id': "8",
      "title": "Logout",
      "dec": "Logout from your account",
      "showArrow": true,
      "icon": AssetsPaths.logout,
      "color": AppColors.redColor.withOpacity(0.8),
      "show": true,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    nameController.text = AppState.vendorName.value;
    firstMethod();
  }

  firstMethod() async {
    isLoading.value = true;
    profileImageBoundary();

    await fetchCurrentPlanData();
    isLoading.value = false;
  }

  doTask(String id, BuildContext context) {
    switch (id) {
      case '1':
        // AppNavigation.goToCreditsPage();
        break;
      case '2':
        // AppNavigation.goToReferAndEarnPage();
        break;
      case '3':
        AppNavigation.goToTransactionHistoryPage();
        break;
      case '4':
        AppNavigation.goToDairySettingsPage();
        break;
      case '5':
        {
          showLanguageSheet(context, LanguagePage());
        }
        break;
      case '6':
      // AppNavigation.goToHelpAndSupportPage();
      case '7':
        {
          //
        }
      case '8':
        {
          showLogoutSheet(context, 'app_logout_msg', true, false);
        }
        break;
    }
  }

  Future<void> fetchCurrentPlanData() async {
    try {
      Map response = await getCurrentPlanUsecase();

      if (response['success']) {
        hasError.value = false;
        Map json = response['currentPlan'];
        currentPlan = CurrentPlanModel.fromJson(json);
        showplanBox.value = true;
        startPlanProgress(
          totalDays: currentPlan.validityDays,
          remainingDays: currentPlan.remainingDays,
        );
      } else {
        showAppToastMessage(response['message'], true);
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    }
  }

  void profileImageBoundary() {
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

  void startPlanProgress({required int totalDays, required int remainingDays}) {
    double target = remainingDays / totalDays;

    animation = Tween<double>(begin: 0, end: target).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationController.forward();

    animation.addListener(() {
      subscriptionProgressLine.value = animation.value;
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Color getProgressColor(double progress) {
    if (progress > 0.4) return AppColors.themeColor;
    if (progress > 0.1) return AppColors.secondaryDark;
    return AppColors.redColor.withOpacity(0.8);
  }

  showLogoutSheet(
    BuildContext context,
    String message,
    bool isLogout,
    bool isAccountDelete,
  ) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          if (isLogout) {
            AppNavigation.goBack();
            final refreshToken = await SecureStorage().getRefreshToken();
            await authSerive.logoutVendroRemote(refreshToken, dio);
            showAppToastMessage(
              'Logged Out!',
              false,
              backgroundColor: AppColors.whiteColor,
              textColor: AppColors.blackColor,
            );
          } else {
            if (isAccountDelete) {
              isDeleting.value = true;

              Future.delayed(Duration(seconds: 1), () {
                isDeleting.value = false;
                isDeleteProcessed.value = true;
              });

              await SharedPrefsService.instance.saveAccountDeleteRequestStatus(
                true,
              );
            } else {
              isDeleting.value = true;

              Future.delayed(Duration(seconds: 1), () {
                isDeleting.value = false;
                isDeleteProcessed.value = false;
              });

              await SharedPrefsService.instance.saveAccountDeleteRequestStatus(
                false,
              );
            }
            AppNavigation.goBack();
          }
        },
      ),
    );
  }

  showLanguageSheet(BuildContext context, Widget child) {
    showMyBottomSheet(context, child);
  }

  openChangeNameSheet(BuildContext context, Widget child) {
    showDragableBottomSheet(context, child);
  }

  Future<void> updateDairyName() async {
    try {
      if (isUpdatingName.value) return;
      isUpdatingName.value = true;
      Map response = await updateVendorNameUsecase(nameController.text.trim());

      if (response['success']) {
        AppState.vendorName.value = response['data'];
        nameController.text = AppState.vendorName.value;
        showAppToastMessage(response['message'], false);
        AppNavigation.goBack();
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isUpdatingName.value = false;
    }
  }
}
