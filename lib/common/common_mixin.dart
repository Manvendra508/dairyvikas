// lib/core/mixins/common_mixin.dart

import 'dart:io';

import 'package:DairyVikas/app/extensions/datetime_ext.dart';
import 'package:DairyVikas/app/theme/app_colors.dart';
import 'package:DairyVikas/common/common_widget/photo_thought_widget.dart';
import 'package:DairyVikas/common/common_widget/text_widget.dart';
import 'package:DairyVikas/core/local_datasources/local_storage_service.dart';
import 'package:DairyVikas/core/local_datasources/secured_storage_service.dart';
import 'package:DairyVikas/core/network/api_endpoints.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

mixin CommonMixin {
  void showAppToastMessage(
    String title,
    bool isError, {
    Color? backgroundColor,
    Color? textColor,
    ToastPosition? position,
  }) {
    showToastWidget(
      Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isError
              ? AppColors.redColor.withOpacity(0.8)
              : backgroundColor ?? AppColors.themeColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: TextWidget(
            textAlign: TextAlign.center,
            text: title,
            fontSize: 12.sp,
            textColor: textColor ?? AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      position: position ?? ToastPosition.top,
      duration: Duration(seconds: 3),
      animationCurve: Curves.easeInOutCubic,
      animationDuration: Duration(milliseconds: 1000),
    );
  }

  showDialogBox({
    required BuildContext context,
    required Widget child,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),

          title: Align(
            alignment: Alignment.center,
            child: TextWidget(
              text: title,
              textColor: AppColors.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: child,
        );
      },
    );
  }

  void showMyBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }

  void showThoughtBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: SingleChildScrollView(child: PhotoThoughtWidget()),
          ),
        );
      },
    );
  }

  String getRateChartHeaderText(int chartType) {
    switch (chartType) {
      case 1:
        return 'FAT';
      case 2:
        return 'CLR';
      case 3:
        return 'FAT/SNF';
      case 4:
        return 'FAT/CLR';
      case 5:
        return 'FAT/CLR + Auto-SNF';
      case 6:
        return '"Liter';
      default:
        return 'Unknown';
    }
  }

  String getLocal() {
    Locale? locale = SharedPrefsService.instance.getSavedLocale();
    if (locale == null) return '';
    return locale.languageCode;
  }

  Future saveDataSensitiveData({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SecureStorage.instance.saveVendorLoginStatus('true');
    await SecureStorage.instance.saveAccessToken(accessToken);
    await SecureStorage.instance.saveRefreshToken(refreshToken);
  }

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    // 2️⃣ Request permission
    PermissionStatus status = await permission.request();

    // if (status.isDenied) {
    //   showAppToastMessage('Permission denied', true);

    //   return null;
    // }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return null;
    }

    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return null;

    return File(file.path);
  }

  Future genrateAndSaveDeviceId() async {
    var uuid = Uuid();
    await SecureStorage.instance.saveVendorDeviceid(uuid.v1());
  }

  Future genrateAndSaveUserAgent() async {
    String userAgent = await getUserAgent();
    await SecureStorage.instance.saveVendorUserAgent(userAgent);
  }

  Future<String> getUserAgent() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return "${packageInfo.appName}/${packageInfo.version} "
          "(Android ${android.version.release}; ${android.model})";
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return "${packageInfo.appName}/${packageInfo.version} "
          "(iOS ${ios.systemVersion}; ${ios.name})";
    }

    return "Unknown-User-Agent";
  }

  Future<bool> fetchStateAndCityData(String pincode) async {
    final dio = Dio();
    bool isVarified = false;
    try {
      String url = '${ApiEndpoints.pincodeApi}$pincode';
      final response = await dio.get(url);

      if (response.statusCode == 200 &&
          response.data[0]['Status'] == 'Success') {
        final data = response.data[0];
        String state = data['PostOffice'][0]['State'];
        String district = data['PostOffice'][0]['District'];
        if (district.isNotEmpty && state.isNotEmpty) {
          isVarified = true;
        }
      } else {
        throw Exception('Failed to load pincode data');
      }
    } catch (_) {}

    return isVarified;
  }

  void showDragableBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<PlatformFile?> pickExcelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first;
      }
      return null;
    } catch (e) {
      debugPrint("Error picking Excel file: $e");
      showAppToastMessage('File Not choosen', true);
      return null;
    }
  }

  String getMilkType(String id) {
    if (id == '1') {
      return 'Cow';
    } else if (id == '2') {
      return 'Buffalo';
    } else if (id == '3') {
      return "Cow + Buffalo";
    } else {
      return "unavailable";
    }
  }

  String formatDate(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  String getWeekDay(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String weekday = DateFormat('EEEE').format(parsedDate);
    return weekday;
  }

  String formatDateforApi(DateTime date) {
    // final parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // String formatDateAndTimeforApi(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  // }

  String formatDateAndTimeforApi(
    DateTime dateTime, {
    bool isTimeSelected = true,
  }) {
    final finalDateTime = isTimeSelected
        ? dateTime
        : DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            0,
            0,
            0,
          ); // 12:00 AM

    return DateFormat('yyyy-MM-dd HH:mm:ss').format(finalDateTime);
  }

  // String formatDateTime(String isoDate) {
  //   try {
  //     DateTime dateTime = DateTime.parse(isoDate).toLocal();

  //     return DateFormat("MMMM d, yyyy • h:mm a").format(dateTime);
  //   } catch (e) {
  //     return isoDate;
  //   }
  // }

  String formatDateTimeForUi(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate).toLocal();

      return DateFormat("MMMM d, yyyy • h:mm a").format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  Future<void> makePhoneCall(String mobileNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: mobileNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not make call to $mobileNumber';
    }
  }

  bool compareDate(DateTime selectedDate) {
    final now = DateTime.now();

    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final today = DateTime(now.year, now.month, now.day);

    return !selected.isAfter(today);
  }

  // Future<String?> pickDate({
  //   required BuildContext context,
  //   DateTime? initialDate,
  //   DateTime? minDate,
  //   DateTime? maxDate,
  //   bool? isFromNotice,
  // }) async {
  //   DateTime selectedDate = initialDate ?? DateTime.now();

  //   return await showDialog<String>(
  //     context: context,
  //     barrierDismissible: false,

  //     builder: (_) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Select Date',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           height: 350.h,
  //           child: SfDateRangePicker(
  //             selectionColor: AppColors.themeColor,
  //             selectionMode: DateRangePickerSelectionMode.single,
  //             initialSelectedDate: selectedDate,
  //             minDate: minDate,
  //             maxDate: maxDate,
  //             onSelectionChanged: (args) {
  //               if (args.value is DateTime) {
  //                 selectedDate = args.value;
  //               }
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (isFromNotice != null && isFromNotice == true) {
  //                 Navigator.pop(context, formatDateforApi(selectedDate));
  //               } else {
  //                 if (!compareDate(selectedDate)) {
  //                   showAppToastMessage('Future date not allowed', true);
  //                   return;
  //                 }
  //                 Navigator.pop(context, formatDateforApi(selectedDate));
  //               }
  //             },

  //             child: const Text('done'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<String?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    bool? isFromNotice,
  }) async {
    DateTime selectedDate = initialDate ?? DateTime.now();
    TimeOfDay? selectedTime;
    TimeOfDay initialTime = TimeOfDay.fromDateTime(selectedDate);

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: TextWidget(
            text: isFromNotice == null || isFromNotice == false
                ? 'select_date'
                : 'select_date_time',
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400.h,
            child: Column(
              children: [
                /// DATE PICKER
                Expanded(
                  child: SfDateRangePicker(
                    selectionColor: AppColors.themeColor,
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedDate: selectedDate,
                    minDate: minDate,
                    maxDate: maxDate,
                    onSelectionChanged: (args) {
                      if (args.value is DateTime) {
                        selectedDate = args.value;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Visibility(
                  visible: isFromNotice ?? false,
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (pickedTime != null) {
                        selectedTime = pickedTime;
                      }
                    },
                    child: const Text('select_time'),
                  ),
                ),
              ],
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
                if (isFromNotice != null && isFromNotice == true) {
                  /// Combine Date + Time
                  if (selectedTime == null) {
                    if (selectedDate.isToday) {
                      showAppToastMessage('please_select_time_also', true);
                      return;
                    }
                    final combinedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                    );

                    Navigator.pop(
                      context,
                      formatDateAndTimeforApi(
                        combinedDateTime,
                        isTimeSelected: false,
                      ),
                    );
                  } else {
                    final combinedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );

                    Navigator.pop(
                      context,
                      formatDateAndTimeforApi(
                        combinedDateTime,
                        isTimeSelected: true,
                      ),
                    );
                  }
                } else {
                  if (!compareDate(selectedDate)) {
                    showAppToastMessage('future_date/time_not_allowed', true);
                    return;
                  }
                  Navigator.pop(context, formatDateforApi(selectedDate));
                }
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

  Future<List<String>> pickContactWithPermission() async {
    List<String> contactDetails = [];
    // final status = await Permission.contacts.status;
    contactDetails = await _openContactPicker();
    // if (status.isGranted) {
    //   contactDetails = await _openContactPicker();
    // } else if (status.isDenied) {
    //   final result = await Permission.contacts.request();
    //   if (result.isGranted) {
    //     contactDetails = await _openContactPicker();
    //   } else {
    //     openAppSettings(); // 🚀 Opens settings
    //   }
    // } else if (status.isPermanentlyDenied) {
    //   openAppSettings(); // 🚀 Directly open settings
    // }
    return contactDetails;
  }

  Future<List<String>> _openContactPicker() async {
    List<String> contactDetails = [];
    // try {
    //   final contact = await FlutterContacts.openExternalPick();
    //   if (contact != null && contact.phones.isNotEmpty) {
    //     final name = contact.displayName;
    //     final phone = contact.phones.first.number;
    //     contactDetails.add(name);
    //     contactDetails.add(phone);
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }

    try {
      final FlutterNativeContactPicker contactPicker =
          FlutterNativeContactPicker();

      // Select a single contact
      final contact = await contactPicker.selectContact();
      if (contact == null) return [];
      contactDetails.add(contact.fullName ?? '');
      contactDetails.add(
        contact.phoneNumbers == null ? '' : contact.phoneNumbers!.first,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return contactDetails;
  }

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  String formatPrice(String price) {
    final number = num.tryParse(price) ?? 0;
    return NumberFormat('#,##0', 'en_IN').format(number);
  }

  Future<void> openWhatsApp({
    required String phone,
    String message = '',
  }) async {
    final Uri uri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("WhatsApp not installed");
    }
  }

  Future<void> shareLink(RxBool isSharing) async {
    if (isSharing.value) return;

    isSharing.value = true;

    try {
      await SharePlus.instance.share(
        ShareParams(text: 'Check out my website https://youtube.com'),
      );

      await Future.delayed(const Duration(seconds: 1));
    } finally {
      isSharing.value = false;
    }
  }
}
