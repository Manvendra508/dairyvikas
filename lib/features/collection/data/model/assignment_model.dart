import '../../domain/entities/assignment_entity.dart';

class AssignmentModel extends AssignmentEntity {
  AssignmentModel({
    required super.dairyId,
    required super.supplierId,
    required super.rateChartId,
    required super.buyerId,
  });

  /// ---------- FROM JSON ----------
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      dairyId: json['dairy_id'],
      supplierId: json['supplier_id'],
      rateChartId: json['rate_chart_id'] ?? 0,
      buyerId: json['buyer_id'],
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "dairy_id": dairyId,
      "supplier_id": supplierId,
      "rate_chart_id": rateChartId,
      "buyer_id": buyerId,
    };
  }

  /// ---------- EMPTY ----------
  factory AssignmentModel.empty() {
    return AssignmentModel(
      dairyId: null,
      supplierId: null,
      rateChartId: 0,
      buyerId: null,
    );
  }
}
