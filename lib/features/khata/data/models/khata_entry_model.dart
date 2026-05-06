import '../../domain/entity/khata_entry_entity.dart';

class KhataEntryModel extends KhataEntryEntity {
  KhataEntryModel({
    required super.id,
    required super.khatabookUserId,
    required super.type,
    required super.amount,
    required super.note,
    required super.createdAt,
    required super.updatedAt,
    required super.entryUser,
  });

  factory KhataEntryModel.fromJson(Map<String, dynamic> json) {
    return KhataEntryModel(
      id: json['id'],
      khatabookUserId: json['khatabook_user_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      entryUser: EntryUserModel.fromJson(json['entry_user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'khatabook_user_id': khatabookUserId,
      'type': type,
      'amount': amount,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'entry_user': (entryUser as EntryUserModel).toJson(),
    };
  }
}

class EntryUserModel extends EntryUserEntity {
  EntryUserModel({
    required super.id,
    required super.dairyId,
    required super.name,
    required super.mobile,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EntryUserModel.fromJson(Map<String, dynamic> json) {
    return EntryUserModel(
      id: json['id'],
      dairyId: json['dairy_id'],
      name: json['name'],
      mobile: json['mobile'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dairy_id': dairyId,
      'name': name,
      'mobile': mobile,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
