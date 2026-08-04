import 'dart:async';

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:get/get.dart';

class ScanDevicesController extends GetxController with CommonMixin {
  RxBool isScanning = false.obs;
  var printerManager = PrinterManager.instance;
  StreamSubscription? _scanSubscription;

  List<PrinterDevice> printers = [];

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
    printers.clear();
    _scanSubscription = printerManager
        .discovery(type: PrinterType.bluetooth, isBle: true)
        .listen((device) {
          printers.add(device);
          update();
          // Add to your list of printers here
        });
  }

  void stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  Future<void> connectPrinter(PrinterDevice printer) async {
    bool isConnected = await printerManager.connect(
      type: PrinterType.bluetooth,
      model: BluetoothPrinterInput(
        name: printer.name,
        address: printer.address!,
        isBle: false,
        autoConnect: true,
      ),
    );
    if (isConnected) {
      print('${printer.address} is connected');
    } else {
      print(" connection failed!");
    }
  }

  Future<void> printReceipt() async {
    final generator = Generator(PaperSize.mm58, await CapabilityProfile.load());

    List<int> bytes = [];

    bytes += generator.text(
      'Dairy Vikas',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.hr();

    bytes += generator.text('Milk 20');
    bytes += generator.text('Rate 60');

    bytes += generator.hr();

    bytes += generator.text(
      'Thank You Rudra',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();

    await printerManager.send(type: PrinterType.bluetooth, bytes: bytes);
  }

  // Future savePrinterMacAddress() async {
  //   await prefs.setString('printer_address', printer.address!);
  // }
}
