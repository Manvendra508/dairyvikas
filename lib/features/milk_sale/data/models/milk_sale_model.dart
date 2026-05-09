import 'package:DairyVikas/features/milk_sale/domain/entity/milk_sale_entity.dart';

class MilkSaleModel extends MilkSaleEntity {
  const MilkSaleModel({
    required super.saleId,
    required super.buyerId,
    required super.shiftId,
    required super.milkTypeId,
    required super.litre,
    required super.fat,
    required super.snf,
    required super.clr,
    required super.ratePerLitre,
    required super.totalAmount,
    required super.saleDate,
    required super.saleBuyer,
  });

  /// -------- FROM JSON --------
  factory MilkSaleModel.fromJson(Map<String, dynamic> json) {
    return MilkSaleModel(
      saleId: json['sale_id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      shiftId: json['shift_id'] ?? 0,
      milkTypeId: json['milk_type_id'] ?? 0,
      litre: (json['litre'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      snf: (json['snf'] as num?)?.toDouble() ?? 0.0,
      clr: (json['clr'] as num?)?.toDouble(),
      ratePerLitre: (json['rate_per_litre'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      saleDate: json['sale_date'] ?? '',
      saleBuyer: SaleBuyerModel.fromJson(json['sale_buyer'] ?? {}),
    );
  }

  /// -------- TO JSON --------
  Map<String, dynamic> toJson() {
    return {
      "sale_id": saleId,
      "buyer_id": buyerId,
      "shift_id": shiftId,
      "milk_type_id": milkTypeId,
      "litre": litre,
      "fat": fat,
      "snf": snf,
      "clr": clr,
      "rate_per_litre": ratePerLitre,
      "total_amount": totalAmount,
      "sale_date": saleDate,
      "sale_buyer": (saleBuyer as SaleBuyerModel).toJson(),
    };
  }

  /// -------- EMPTY --------
  factory MilkSaleModel.empty() {
    return MilkSaleModel(
      saleId: 0,
      buyerId: 0,
      shiftId: 0,
      milkTypeId: 0,
      litre: 0,
      fat: 0,
      snf: 0,
      clr: null,
      ratePerLitre: 0,
      totalAmount: 0,
      saleDate: '',
      saleBuyer: SaleBuyerModel.empty(),
    );
  }
}

class SaleBuyerModel extends SaleBuyerEntity {
  const SaleBuyerModel({
    required super.buyerName,
    required super.milkBuyerCode,
  });

  factory SaleBuyerModel.fromJson(Map<String, dynamic> json) {
    return SaleBuyerModel(
      buyerName: json['buyer_name'] ?? '',
      milkBuyerCode: json['milk_buyer_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"buyer_name": buyerName, "milk_buyer_code": milkBuyerCode};
  }

  factory SaleBuyerModel.empty() {
    return const SaleBuyerModel(buyerName: '', milkBuyerCode: '');
  }
}
