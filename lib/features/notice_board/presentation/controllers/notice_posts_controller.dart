import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/utils/app_icons.dart';
import 'package:DairyVikas/features/notice_board/data/models/notice_post_model.dart';
import 'package:DairyVikas/features/notice_board/domain/usecases/get_notices_posts_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoticePostsController extends GetxController with CommonMixin {
  final GetNoticesPostsUsecase _getNoticesPostsUsecase;

  RxBool hasError = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  RxList<NoticeModel> noticePosts = <NoticeModel>[].obs;

  RxBool isLoading = false.obs;
  List<NoticeModel> filterednoticePosts = <NoticeModel>[];

  RxString selectedStatus = '0'.obs;

  RxList<Map<String, dynamic>> statusFilters = <Map<String, dynamic>>[
    {"id": '0', "title": 'all'},
    {"id": '1', "title": 'Active'},
    {"id": '2', "title": 'Scheduled'},
    {"id": '3', "title": 'Expired'},
  ].obs;

  NoticePostsController(this._getNoticesPostsUsecase);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllNoticesPosts();
  }

  Future getAllNoticesPosts() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getNoticesPostsUsecase(dairyId);

      if (response['success']) {
        hasError.value = false;
        noticePosts.clear();

        List stocksJson = response['data'] as List;

        noticePosts.assignAll(
          stocksJson.map((item) => NoticeModel.fromJson(item)).toList(),
        );
        filterednoticePosts.assignAll(noticePosts);
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

  selectStatus(int index) {
    currentStatusFilterIndex.value = index;
    selectedStatus.value = statusFilters[index]['id'];
    // filterStockItems();
  }

  // filterStockItems() {
  //   if (selectedStatus.value == '0') {
  //     filterednoticePosts.assignAll(noticePosts);
  //   } else if (selectedStatus.value == '1') {
  //     filterednoticePosts.assignAll(
  //       noticePosts.where((p) => p.flags.isActive).toList(),
  //     );
  //   } else if (selectedStatus.value == '2') {
  //     filterednoticePosts.assignAll(
  //       noticePosts.where((p) => p.flags.isScheduled).toList(),
  //     );
  //   } else if (selectedStatus.value == '3') {
  //     filterednoticePosts.assignAll(
  //       noticePosts.where((p) => p.flags.isExpired).toList(),
  //     );
  //   }

  //   update();
  // }

  String getDateStringMessage(String key, NoticeModel notice) {
    bool isEdited =
        notice.updatedAt != null &&
        !notice.createdAt!.isAtSameMomentAs(notice.updatedAt!);
    if (key == 'active') {
      return 'Posted on: ${formatDate(notice.createdAt!.toIso8601String())} ${isEdited ? '(Edited)' : ""}';
    } else if (key == 'scheduled') {
      return 'Schedule for: ${DateFormat('dd MMM, yyyy • hh:mm a').format(notice.scheduleDate!)} ${isEdited ? '(Edited)' : ""}';
    } else {
      return 'Expired on: ${formatDate(notice.expiryDate!.toIso8601String())}';
    }
  }

  String getPostStatus(String key) {
    if (key == 'active') {
      return 'Active';
    } else if (key == 'scheduled') {
      return 'Scheduled';
    } else {
      return 'Expired';
    }
  }

  Color getPostStatusColor(String key) {
    if (key == 'active') {
      return AppColors.themeColor;
    } else if (key == 'scheduled') {
      return AppColors.blue;
    } else {
      return AppColors.redColor;
    }
  }

  Widget getPostStatusIcon(String key) {
    if (key == 'active') {
      return AppIcons.acitve(color: AppColors.themeColor);
    } else if (key == 'scheduled') {
      return AppIcons.history(color: AppColors.blue);
    } else {
      return AppIcons.expired(color: AppColors.redColor);
    }
  }
}
