import 'dart:convert';

import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/registration_flow/data/model/vendor_model.dart';
import '../../features/dashboard/data/model/recent_search_model.dart';

class SharedPrefsService {
  SharedPrefsService._internal();

  static final SharedPrefsService _instance = SharedPrefsService._internal();

  static SharedPrefsService get instance => _instance;

  late SharedPreferences _prefs;

  static const String recentSearchKey = 'recent_search';
  static const String dairyDetailsKey = 'dairy_details';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveDairyId(String value) async {
    await _prefs.setString('dairy_id', value);
  }

  Future<String?> getDairyId() async {
    return _prefs.getString('dairy_id');
  }

  Future<void> savedairyDetailsSikped(bool skip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dairy_details_skiped', skip);
  }

  Future<bool> getdairyDetailsSikped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dairy_details_skiped') ?? false;
  }

  Future<void> saveVendor(VendorModel vendor) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(vendor.toJson());

    await prefs.setString("vendor", jsonString);
  }

  Future<VendorModel?> getVendor() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("vendor");

    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return VendorModel.fromJson(jsonMap);
  }

  Future<void> saveDairyDetails(DairyModel dairyDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(dairyDetails.toJson());

    await prefs.setString(dairyDetailsKey, jsonString);
  }

  Future<DairyModel?> getDairyDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(dairyDetailsKey);

    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DairyModel.fromJson(jsonMap);
  }

  Future<void> saveLanguage(String code, String country) async {
    await _prefs.setString('lang_code', code);
    await _prefs.setString('lang_country', country);
  }

  Future<void> saveAccountDeleteRequestStatus(bool status) async {
    await _prefs.setBool('account_delete', status);
  }

  Future<bool> getAccountDeleteRequestStatus() async {
    return _prefs.getBool('account_delete') ?? false;
  }

  Future<void> saveRateChart(List<List<double>> matrix) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert to JSON-safe structure
    final jsonString = jsonEncode(matrix);

    await prefs.setString('rate_chart', jsonString);
  }

  Future<List<List<double>>> getRateChart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('rate_chart');

    if (jsonString == null) return [];

    final decoded = jsonDecode(jsonString) as List;

    return decoded
        .map((row) => (row as List).map((e) => (e as num).toDouble()).toList())
        .toList();
  }

  Locale? getSavedLocale() {
    final code = _prefs.getString('lang_code');
    final country = _prefs.getString('lang_country');
    if (code == null) return null;
    return Locale(code, country);
  }

  static Future<void> saveRecentSearch(RecentSearch item) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> storedList = prefs.getStringList(recentSearchKey) ?? [];

    List<RecentSearch> list = storedList
        .map((e) => RecentSearch.fromJson(jsonDecode(e)))
        .toList();

    // Remove if already exists (avoid duplicate)
    list.removeWhere((e) => e.id == item.id);

    // Add to top
    list.insert(0, item);

    // Keep only 5
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }

    // Save again
    List<String> jsonList = list.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(recentSearchKey, jsonList);
  }

  /// GET ALL SEARCHES
  static Future<List<RecentSearch>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> storedList = prefs.getStringList(recentSearchKey) ?? [];

    return storedList.map((e) => RecentSearch.fromJson(jsonDecode(e))).toList();
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
