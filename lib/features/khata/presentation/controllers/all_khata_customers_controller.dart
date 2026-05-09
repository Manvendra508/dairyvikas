import 'package:DairyVikas/common/common_mixin.dart';
import 'package:DairyVikas/core/error/exceptions.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/features/khata/data/models/khatabook_user_model.dart';
import 'package:DairyVikas/features/khata/domain/usecases/get_khatabook_customers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AllKhataCustomersController extends GetxController with CommonMixin {
  final GetKhatabookCustomersUseCase _getKhatabookCustomers;

  RxBool hasError = false.obs;
  RxBool isLoading = false.obs;
  RxInt currentStatusFilterIndex = 0.obs;
  int totalCredit = 0;
  int totalDebit = 0;
  String totalPayee = '0';
  String totalReceivables = '0';
  RxList<KhatabookUserModel> khataCustomers = <KhatabookUserModel>[].obs;
  List<KhatabookUserModel> filteredKhataCustomers = <KhatabookUserModel>[];

  final searchController = TextEditingController();
  AllKhataCustomersController(this._getKhatabookCustomers);
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  Future firstMethod() async {
    await getAllKhataCustomers();
  }

  Future getAllKhataCustomers() async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;
      final String dairyId =
          await SharedPrefsService.instance.getDairyId() ?? '0';
      Map response = await _getKhatabookCustomers(dairyId);

      if (response['success']) {
        hasError.value = false;
        khataCustomers.clear();

        List khatabookUsersJson = response['data']['users'] as List;
        totalCredit = response['data']['summary']['overall_credit'] ?? 0;
        totalDebit = response['data']['summary']['overall_debit'] ?? 0;
        khataCustomers.assignAll(
          khatabookUsersJson
              .map((item) => KhatabookUserModel.fromJson(item))
              .toList(),
        );
        filteredKhataCustomers.assignAll(khataCustomers);

        totalPayee = khataCustomers
            .where((ku) => ku.balance < 0)
            .length
            .toString();

        totalReceivables = khataCustomers
            .where((ku) => ku.balance > 0)
            .length
            .toString();
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

  searchRecord(String searchTerm) {
    filteredKhataCustomers.assignAll(
      khataCustomers.where(
        (ks) =>
            ks.name.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
            ks.mobile.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
            (-ks.balance).toString().startsWith(searchTerm),
      ),
    );
    update();
  }

  String timeAgo(String isoDate) {
    if (isoDate.isEmpty) return 'Date Unavailable';
    final DateTime dateTime = DateTime.parse(isoDate).toLocal();
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} sec ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else {
      return '${(diff.inDays / 365).floor()} years ago';
    }
  }
}
