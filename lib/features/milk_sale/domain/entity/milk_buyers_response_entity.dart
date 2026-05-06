import 'package:dairysathi/features/milk_sale/data/models/milk_buyer_model.dart';

class MilkBuyerResponseEntity {
  final bool success;
  final String message;
  final List<MilkBuyerModel> buyers;
  final int totalCount;
  final int deletedCount;
  final int activeCount;
  final int inactiveCount;

  const MilkBuyerResponseEntity({
    required this.success,
    required this.message,
    required this.buyers,
    required this.totalCount,
    required this.deletedCount,
    required this.activeCount,
    required this.inactiveCount,
  });
}
