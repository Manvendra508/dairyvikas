import '../../data/model/collection_can_model.dart';
import '../../data/model/collection_model.dart';

class CollectionEntity {
  final int collectionId;
  final int supplierId;
  final int collectionShiftId;
  final int milkTypeId;

  final int litre;
  final double fat;
  final double? snf;
  final double? clr;
  final int sampleCount;
  final double ratePerLitre;
  final double totalAmount;
  String collectionDate = '';
  final List<CanStepModel> steps;

  CollectionSupplierModel collectionSupplier;

  CollectionEntity({
    required this.collectionId,
    required this.supplierId,
    required this.collectionShiftId,
    required this.milkTypeId,
    required this.litre,
    required this.fat,
    required this.snf,
    required this.clr,
    required this.ratePerLitre,
    required this.totalAmount,
    required this.collectionDate,
    required this.collectionSupplier,
    required this.steps,
    required this.sampleCount,
  });
}

class CollectionSupplierEntity {
  final String supplierName;
  final String milkSupplierCode;

  const CollectionSupplierEntity({
    required this.supplierName,
    required this.milkSupplierCode,
  });
}
