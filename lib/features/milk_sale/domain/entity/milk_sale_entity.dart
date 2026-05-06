class MilkSaleEntity {
  final int saleId;
  final int buyerId;
  final int shiftId;
  final int milkTypeId;
  final double litre;
  final double fat;
  final double snf;
  final double? clr;
  final double ratePerLitre;
  final double totalAmount;
  final String saleDate;
  final SaleBuyerEntity saleBuyer;

  const MilkSaleEntity({
    required this.saleId,
    required this.buyerId,
    required this.shiftId,
    required this.milkTypeId,
    required this.litre,
    required this.fat,
    required this.snf,
    required this.clr,
    required this.ratePerLitre,
    required this.totalAmount,
    required this.saleDate,
    required this.saleBuyer,
  });
}

class SaleBuyerEntity {
  final String buyerName;
  final String milkBuyerCode;

  const SaleBuyerEntity({required this.buyerName, required this.milkBuyerCode});
}
