import 'package:get/get.dart';

class AssignalbeSupplierEntity {
  final int id;
  final RxBool isSelected;
  final String supplierName;
  final String milkSupplierCode;
  final String supplierMobile;

  AssignalbeSupplierEntity({
    required this.isSelected,
    required this.id,
    required this.supplierName,
    required this.milkSupplierCode,
    required this.supplierMobile,
  });
}
