import 'dart:typed_data' show Uint8List;

import 'package:DairyVikas/common/common_mixin.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomerPdfSheetController extends GetxController with CommonMixin {
  final List<CustomerMilkData> customers = [
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C001',
      name: 'Ramesh',
      liter: 12.5,
      fat: 4.2,
      clr: 28,
    ),
    CustomerMilkData(
      code: 'C002',
      name: 'Suresh',
      liter: 10.0,
      fat: 3.8,
      clr: 26,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),

    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
    CustomerMilkData(
      code: 'C003',
      name: 'Mahesh',
      liter: 15.3,
      fat: 4.5,
      clr: 30,
    ),
  ];

  // @override
  // void onInit() {
  //   setSupplierDataForUpdate();
  //   super.onInit();
  // }

  Future<Uint8List> generateCustomerPdf({
    required String dairyName,
    required String dairyLocation,
    required String title,
    required bool isCow,
    required bool isBuffalo,
    required bool isMorning,
    required bool isEvening,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          /// ---------- HEADER ----------
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                dairyName,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(dairyLocation, style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 8),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 16),

          /// ---------- CHECKBOX SECTION ----------
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  _checkBox(isCow, 'Cow'),
                  pw.SizedBox(width: 10),
                  _checkBox(isBuffalo, 'Buffalo'),
                ],
              ),
              pw.Row(
                children: [
                  _checkBox(isMorning, 'Morning'),
                  pw.SizedBox(width: 10),
                  _checkBox(isEvening, 'Evening'),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 16),

          /// ---------- TABLE ----------
          pw.Table(
            border: pw.TableBorder.all(width: 0.6),
            columnWidths: const {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
            },
            children: [_tableHeader(), ...customers.map(_tableRow)],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _checkBox(bool checked, String label) {
    return pw.Row(
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: checked
              ? pw.Center(
                  child: pw.Container(
                    width: 6,
                    height: 6,
                    color: PdfColors.black,
                  ),
                )
              : null,
        ),
        pw.SizedBox(width: 4),
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  pw.TableRow _tableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        _cell('Code', isHeader: true),
        _cell('Customer Name', isHeader: true),
        _cell('Liter', isHeader: true),
        _cell('FAT', isHeader: true),
        _cell('CLR', isHeader: true),
      ],
    );
  }

  pw.TableRow _tableRow(CustomerMilkData c) {
    return pw.TableRow(
      children: [
        _cell(c.code),
        _cell(c.name),
        _cell(c.liter.toStringAsFixed(2)),
        _cell(c.fat.toStringAsFixed(1)),
        _cell(c.clr.toStringAsFixed(1)),
      ],
    );
  }

  pw.Widget _cell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

class CustomerMilkData {
  final String code;
  final String name;
  final double liter;
  final double fat;
  final double clr;

  CustomerMilkData({
    required this.code,
    required this.name,
    required this.liter,
    required this.fat,
    required this.clr,
  });
}
