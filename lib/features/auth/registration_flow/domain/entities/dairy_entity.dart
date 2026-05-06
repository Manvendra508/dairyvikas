class DairyEntity {
  final String id;
  final String dairyName;
  final String state;
  final String district;
  final String village;
  final String taluka;
  final String pincode;
  final String collectionType;
  final String milkType;
  final String collectionShift;
  final String paymentPeriod;
  final String vendorName;

  DairyEntity({
    required this.id,
    required this.dairyName,
    required this.state,
    required this.district,
    required this.village,
    required this.taluka,
    required this.pincode,
    required this.collectionType,
    required this.milkType,
    required this.collectionShift,
    required this.paymentPeriod,
    required this.vendorName,
  });
}
