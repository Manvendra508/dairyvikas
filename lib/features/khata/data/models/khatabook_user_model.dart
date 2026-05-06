import '../../domain/entity/khatacustomers_enttiy.dart';

class KhatabookUserModel extends KhatabookUserEntity {
  const KhatabookUserModel({
    required super.khatabookUserId,
    required super.name,
    required super.mobile,
    required super.totalDebit,
    required super.totalCredit,
    required super.balance,
    required super.latestEntryDate,
  });

  /// 🔹 From JSON
  factory KhatabookUserModel.fromJson(Map<String, dynamic> json) {
    return KhatabookUserModel(
      khatabookUserId: json['khatabook_user_id'] ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      totalDebit: (json['total_debit'] ?? 0).toDouble(),
      totalCredit: (json['total_credit'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      latestEntryDate: json['latest_entry_date'] ?? '',
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      "khatabook_user_id": khatabookUserId,
      "name": name,
      "mobile": mobile,
      "total_debit": totalDebit,
      "total_credit": totalCredit,
      "balance": balance,
      "latest_entry_date": latestEntryDate,
    };
  }

  /// 🔹 Empty model
  factory KhatabookUserModel.empty() {
    return const KhatabookUserModel(
      khatabookUserId: 0,
      name: '',
      mobile: '',
      totalDebit: 0.0,
      totalCredit: 0.0,
      balance: 0.0,
      latestEntryDate: '',
    );
  }
}
