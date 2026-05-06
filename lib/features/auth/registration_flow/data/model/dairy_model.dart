import 'package:dairysathi/features/auth/registration_flow/domain/entities/dairy_entity.dart'
    show DairyEntity;

class DairyModel extends DairyEntity {
  DairyModel({
    required super.id,
    required super.dairyName,
    required super.state,
    required super.district,
    required super.village,
    required super.taluka,
    required super.pincode,
    required super.collectionShift,
    required super.collectionType,
    required super.milkType,
    required super.paymentPeriod,
    required super.vendorName,
  });

  /// ---------- EMPTY MODEL ----------
  factory DairyModel.empty() {
    return DairyModel(
      dairyName: '',
      state: '',
      district: '',
      village: '',
      taluka: '',
      pincode: '',
      collectionShift: '',
      collectionType: '',
      milkType: '',
      paymentPeriod: '',
      id: '',
      vendorName: '',
    );
  }

  /// ---------- FROM JSON ----------
  factory DairyModel.fromJson(Map<String, dynamic> json) {
    return DairyModel(
      id: json['id'].toString(),
      dairyName: json['dairy_name'] ?? '',
      state: json['state'].toString(),
      district: json['district'].toString(),
      village: json['village'] ?? '',
      taluka: json['taluka'] ?? '',
      pincode: json['pincode'].toString(),
      collectionShift: json['collection_shift'].toString(),
      collectionType: json['collection_type'].toString(),
      milkType: json['milk_type'].toString(),
      paymentPeriod: json['payment_period'].toString(),
      vendorName: json['vendorName'].toString(),
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dairy_name": dairyName,
      "state": state,
      "district": district,
      "village": village,
      "taluka": taluka,
      "pincode": pincode,
      "collection_shift": collectionShift,
      "collection_type": collectionType,
      "milk_type": milkType,
      "payment_period": paymentPeriod,
      "vendorName": vendorName,
    };
  }
}
