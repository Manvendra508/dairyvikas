import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/common/common_widget/app_button.dart';
import 'package:DairyVikas/common/common_widget/app_version_text.dart';
import 'package:DairyVikas/common/common_widget/network_image.dart';
import 'package:DairyVikas/common/common_widget/select_bool_option_widget.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart' show AppState;
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/other_services/auth_service.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/core/utils/app_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/local_datasources/secured_storage_service.dart';
import '../../core/utils/gap.dart';

class DairyVikasAppDrawer extends StatefulWidget {
  final String district;
  final String state;
  const DairyVikasAppDrawer({
    super.key,
    required this.district,
    required this.state,
  });

  @override
  State<DairyVikasAppDrawer> createState() => _DairyVikasAppDrawerState();
}

class _DairyVikasAppDrawerState extends State<DairyVikasAppDrawer>
    with CommonMixin {
  final dio = Dio();
  final authSerive = AuthService();
  RxBool isDeleteProcessed = false.obs;
  RxBool isDeleting = false.obs;
  String district = '';
  String state = '';

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
            setState(() {});
          }
        },
      ),
    );
  }

  setLocationData() {
    district = widget.district;
    state = widget.state;
    Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  getAccountdeletionStatus() async {
    isDeleteProcessed.value = await SharedPrefsService.instance
        .getAccountDeleteRequestStatus();
    setState(() {});
  }

  @override
  void initState() {
    setLocationData();
    getAccountdeletionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 1.sh,
      decoration: BoxDecoration(color: AppColors.whiteColor),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Profile',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                InkWell(
                  onTap: () => AppNavigation.goBack(),
                  child: Container(
                    width: 70,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.grey200,
                    ),
                    child: Center(child: AppIcons.arrowForwardRange()),
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.6, color: AppColors.grey200),
            SizedBox(height: 10),
            _buildTopPart(context),
            Spacer(),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    if (isDeleteProcessed.value) return;
                    showLogoutSheet(
                      context,
                      'delete_account_warning',
                      false,
                      true,
                    );
                  },
                  child: Obx(
                    () => AppButton(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      title: isDeleteProcessed.value
                          ? "request_sent"
                          : 'delete_account',
                      buttonFontWeight: FontWeight.w600,
                      isLoading: isDeleting,
                      shadowOpacity: 0.4,
                      buttonColor: isDeleteProcessed.value
                          ? AppColors.grey400
                          : AppColors.redColor.withOpacity(0.8),
                      buttonBorderColor: isDeleteProcessed.value
                          ? AppColors.grey400
                          : AppColors.redColor.withOpacity(0.8),
                    ),
                  ),
                ),
                Gap.verticalGap(3),
                Obx(
                  () => isDeleteProcessed.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: 'account_delete_msg',
                              fontWeight: FontWeight.w600,
                              textColor: AppColors.grey600,
                              fontSize: 9.sp,
                            ),
                            InkWell(
                              onTap: () => showLogoutSheet(
                                context,
                                'account_withdraw_msg',
                                false,
                                false,
                              ),
                              child: TextWidget(
                                text: 'withdraw',
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.blue,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),

                Gap.verticalGap(10),
                InkWell(
                  onTap: () =>
                      showLogoutSheet(context, 'app_logout_msg', true, false),
                  child: AppButton(
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    title: 'logout',
                    buttonTextColor: AppColors.redColor,
                    buttonFontWeight: FontWeight.w600,
                    isLoading: false.obs,
                    buttonColor: AppColors.whiteColor,
                    shadowOpacity: 0.4,
                    buttonBorderColor: AppColors.redColor.withOpacity(0.7),
                  ),
                ),
                Gap.verticalGap(10),
                AppVersionText(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTopPart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          InkWell(
            child: Container(
              width: 67.w,
              height: 57.h,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey300,
              ),
              child: CacheMyNetworkImage(
                fit: BoxFit.cover,

                imgUrl:
                    'https://static.vecteezy.com/system/resources/thumbnails/035/857/753/small/people-face-avatar-icon-cartoon-character-png.png',
                imgRaduis: 100.r,
              ),
            ),
          ),

          Gap.verticalGap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  TextWidget(
                    text: AppState.dairyName.capitalize.toString(),
                    fontSize:
                        AppState.dairyName.capitalize.toString().length > 21
                        ? 15.sp
                        : 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  Row(
                    children: [
                      AppIcons.location(size: 11, color: AppColors.grey500),
                      Gap.horizentalGap(3),
                      TextWidget(
                        text: '$district, $state',
                        fontSize: district.length > 10 ? 11.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.grey500,
                      ),
                    ],
                  ),
                  Gap.verticalGap(20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
