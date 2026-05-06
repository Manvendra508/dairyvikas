import 'package:dairysathi/features/milk_suppliers/data/model/milk_supplier_model.dart';

class MilkSuppliersReponseEntity {
  List<MilkSupplierModel> suppliers = <MilkSupplierModel>[];
  final String totalCount;
  final String deletedCount;
  final String activeCount;
  final String inactiveCount;

  MilkSuppliersReponseEntity({
    required this.suppliers,
    required this.totalCount,
    required this.deletedCount,
    required this.activeCount,
    required this.inactiveCount,
  });
}
