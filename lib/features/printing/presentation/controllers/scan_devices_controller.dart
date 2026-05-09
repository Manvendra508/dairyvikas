import 'dart:async';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:get/get.dart';

class ScanDevicesController extends GetxController with CommonMixin {
  RxBool isScanning = false.obs;
  var printerManager = PrinterManager.instance;
  StreamSubscription? _scanSubscription;

  List deivces = [];

  startScanning() {
    if (isScanning.value) {
      stopScan();
      isScanning.value = false;
    } else {
      startScan();
      isScanning.value = true;
    }
    update();
  }

  void startScan() {
    // Cancel any existing scan before starting a new one
    _scanSubscription?.cancel();
    deivces.clear();
    _scanSubscription = printerManager
        .discovery(type: PrinterType.bluetooth, isBle: true)
        .listen((device) {
          deivces.add(device.name);
          update();
          // Add to your list of printers here
        });
  }

  void stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    print("Scanning stopped.");
  }
}
