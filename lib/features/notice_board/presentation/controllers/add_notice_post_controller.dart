// ignore_for_file: use_build_context_synchronously

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/local_datasources/app_state.dart';
import 'package:DairyVikas/features/notice_board/domain/usecases/add_notice_post_usecase.dart';
import 'package:DairyVikas/features/notice_board/domain/usecases/delete_notice_post_usecase.dart';
import 'package:DairyVikas/features/notice_board/domain/usecases/update_notice_usecase.dart';
import 'package:DairyVikas/features/notice_board/presentation/controllers/notice_posts_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/common_widget/select_bool_option_widget.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/local_datasources/local_storage_service.dart';
import '../../../../core/utils/app_navigation.dart';

class AddNoticePostController extends GetxController with CommonMixin {
  final AddNoticePostUsecase _addNoticePostUsecase;
  final UpdateNoticeUsecase _updateNoticeUsecase;
  final DeleteNoticePostUsecase _deleteNoticePostUsecase;
  final postMesage = TextEditingController();
  RxInt messageLength = 0.obs;
  RxBool isPosting = false.obs;
  RxBool isDeleting = false.obs;
  // RxBool isScheduling = false.obs;
  RxBool isMessageLimitReached = false.obs;
  // RxString selectedScheduleDate = ''.obs;
  // bool hidePostNowButton = false;
  // bool hideSchduleButton = false;
  AddNoticePostController(
    this._addNoticePostUsecase,
    this._updateNoticeUsecase,
    this._deleteNoticePostUsecase,
  );

  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await setDataForUpdate();
  }

  setDataForUpdate() {
    if (!AppState.isNoticePostEdit) return;

    postMesage.text = AppState.currentNoticePostForUpdate.notice;
    messageLength.value = postMesage.text.length;
    // if (AppState.currentNoticePostForUpdate.flags.isScheduled) {
    //   hidePostNowButton = true;
    //   selectedScheduleDate.value = formatDate(
    //     AppState.currentNoticePostForUpdate.scheduleDate!.toIso8601String(),
    //   );
    // } else {
    //   hideSchduleButton = true;
    // }
  }

  // pickDateForSchedulePost(BuildContext context) async {
  //   selectedScheduleDate.value =
  //       await pickDate(
  //         context: context,
  //         isFromNotice: true,
  //         minDate: DateTime.now(),
  //       ) ??
  //       '';
  //   if (selectedScheduleDate.value.isNotEmpty) {
  //     await showDeleteOrPostOption(
  //       context,
  //       'Are you sure to schedule this post on ${getReadableDateAndTime(selectedScheduleDate.value)}?',
  //       false,
  //     );
  //   }
  // }

  getReadableDateAndTime(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString).toLocal();
    return DateFormat('dd MMM, yyyy • hh:mm a').format(dateTime);
  }

  bool validateData() {
    if (postMesage.text.isEmpty) {
      showAppToastMessage('please_write_some_message', true);
      return false;
    }
    return true;
  }

  Future<void> updateNoticePost() async {
    if (!validateData() || isPosting.value) return;

    isPosting.value = true;

    final postData = {
      "dairy_id": AppState.currentNoticePostForUpdate.dairyId,
      "notice": postMesage.text,
      "notice_id": AppState.currentNoticePostForUpdate.id,
      // "isScheduled": AppState.currentNoticePostForUpdate.flags.isScheduled,
    };

    // if (AppState.currentNoticePostForUpdate.flags.isScheduled) {
    //   postData.addAll({'schedule_date': selectedScheduleDate.value});
    // }

    try {
      var response = await _updateNoticeUsecase(postData);
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isPosting.value = false;
    }
  }

  Future<void> removeNoticePost() async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    try {
      var response = await _deleteNoticePostUsecase(
        AppState.currentNoticePostForUpdate.id.toString(),
      );
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> addNewNoticePost(bool isSchduled) async {
    if (!validateData() || isPosting.value) return;

    isPosting.value = true;
    final String dairyId =
        await SharedPrefsService.instance.getDairyId() ?? '0';
    final postData = {
      "dairy_id": dairyId,
      "notice": postMesage.text,
      // "isScheduled": isSchduled,
    };

    // if (isSchduled) {
    //   postData.addAll({'schedule_date': selectedScheduleDate.value});
    // }

    try {
      var response = await _addNoticePostUsecase(postData);
      if (response['success']) {
        _proccessResponse(response);
      } else {
        showAppToastMessage(response['message'], true);
      }
    } catch (e) {
      String errorMessage = AppExceptionHandler.handleError(e);
      showAppToastMessage(errorMessage, true);
    } finally {
      isPosting.value = false;
    }
  }

  _proccessResponse(var response) async {
    final noticePostsController = Get.find<NoticePostsController>();
    showAppToastMessage(response['message'], false);

    await noticePostsController.getAllNoticesPosts();
    AppNavigation.goBack();
  }

  showDeletePostOption(BuildContext context, String message) {
    showMyBottomSheet(
      context,
      SelectBoolOptionWidget(
        message: message,
        title: 'warning',
        callback: () async {
          AppNavigation.goBack();
          await removeNoticePost();
        },
      ),
    );
  }
}
