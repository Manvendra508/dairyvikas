import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/core/local_datasources/local_storage_service.dart';
import 'package:dairysathi/core/utils/app_icons.dart';
import 'package:dairysathi/core/utils/app_navigation.dart';
import 'package:dairysathi/features/dashboard/data/model/recent_search_model.dart';
import 'package:get/get.dart';

class SearchInAppController extends GetxController with CommonMixin {
  String searchedTerm = '';
  RxList searchResultList = [].obs;
  RxList<RecentSearch> recentSearches = <RecentSearch>[].obs;
  RxList searchSuggestionList = [
    {
      "id": "1",
      "name": "Add Milk Supplier",
      "callback": () => AppNavigation.goToAddMilkSupplierPage(),
    },
    {
      "id": "2",
      "name": "Add Milk Buyer",
      "callback": () => AppNavigation.goToAddMilkBuyerPage(),
    },
    {
      "id": "3",
      "name": "Add Food Stock Or Item",
      "callback": () => AppNavigation.goToAddFoodStockPage(false),
    },
    {
      "id": "4",
      "name": "Add Dealer",
      "callback": () => AppNavigation.goToAddDealerPage(),
    },
    {
      "id": "5",
      "name": "Add Food Sale",
      "callback": () => AppNavigation.goToAddFoodSalePage(),
    },
    {
      "id": "6",
      "name": "Add Milk Collection",
      "callback": () => AppNavigation.goToAddNewCollectionPage(false),
    },

    {
      "id": "7",
      "name": "Milk Collections",
      "callback": () => AppNavigation.goToAllCollectionsPage(),
    },

    {
      "id": "8",
      "name": "Add Notice",
      "callback": () => AppNavigation.goToAddNoticePostPage(),
    },

    {
      "id": "8",
      "name": "Add Milk Sale",
      "callback": () => AppNavigation.goToAddMilkSalePage(),
    },

    {
      "id": "9",
      "name": "Add Khata Customer",
      "callback": () => AppNavigation.goToAddKhataCustomerPage(),
    },

    {
      "id": "10",
      "name": "Invoice",
      "callback": () => AppNavigation.goToAllInvoicesPage(),
    },
    {
      "id": "11",
      "name": "Setting",
      "callback": () => AppNavigation.goToDairySettingsPage(),
    },
    {
      "id": "12",
      "name": "Change Language",
      "callback": () => AppNavigation.goToProfilePage(),
    },
    {
      "id": "13",
      "name": "Add Rate Chart",
      "callback": () => AppNavigation.goToAddRateChartPage(),
    },
    {
      "id": "14",
      "name": "My Rate Charts",
      "callback": () => AppNavigation.goToAllRateChartsPage(),
    },

    {
      "id": "15",
      "name": "Subscription Plans",
      "callback": () => AppNavigation.goToSubscriptionPlanPage(),
    },

    {
      "id": "16",
      "name": "My Notice",
      "callback": () => AppNavigation.goToNoticePostsPage(),
    },

    {
      "id": "17",
      "name": "Transaction",
      "callback": () {
        print('go to transaction screen');
      },
    },
    {
      "id": "18",
      "name": "Help And Support",
      "callback": () => AppNavigation.goToProfilePage(),
    },
  ].obs;

  RxList quickAccess = [
    {
      "title": "Transactions",
      "icon": AppIcons.transaction(),
      "id": "1",
      "callback": () => AppNavigation.goToTransactionHistoryPage(),
    },
    {
      "title": "Help & Support",
      "icon": AppIcons.customerSupport(),
      "id": "2",
      "callback": () => AppNavigation.goToProfilePage(),
    },
    {
      "title": "Subscription Plans",
      "icon": AppIcons.premium(),
      "id": "3",
      "callback": () => AppNavigation.goToSubscriptionPlanPage(),
    },
  ].obs;
  @override
  void onInit() {
    firstMethod();
    super.onInit();
  }

  firstMethod() async {
    await getRecentSearches();
  }

  getRecentSearches() async {
    recentSearches.clear();
    recentSearches.addAll(await SharedPrefsService.getRecentSearches());
  }

  searchInApp() {
    searchResultList.assignAll(
      searchSuggestionList.where(
        (suggestion) => suggestion['name'].toString().toLowerCase().contains(
          searchedTerm.toLowerCase(),
        ),
      ),
    );
    if (searchedTerm.isEmpty) {
      searchResultList.clear();
    }
  }

  void navigateFromRecentSearch(String id) {
    var json = searchSuggestionList.firstWhere(
      (item) => item['id'] == id,
      orElse: () => <String, Object>{}, // ✅ FIX
    );

    if (json.isNotEmpty && json['callback'] != null) {
      json['callback'](); // 👈 EXECUTE here
    }
  }
}
