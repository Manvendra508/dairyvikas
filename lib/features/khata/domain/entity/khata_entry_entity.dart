class KhataEntryEntity {
  final int id;
  final int khatabookUserId;
  final String type;
  final double amount;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EntryUserEntity entryUser;

  KhataEntryEntity({
    required this.id,
    required this.khatabookUserId,
    required this.type,
    required this.amount,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.entryUser,
  });
}

class EntryUserEntity {
  final int id;
  final int dairyId;
  final String name;
  final String mobile;
  final DateTime createdAt;
  final DateTime updatedAt;

  EntryUserEntity({
    required this.id,
    required this.dairyId,
    required this.name,
    required this.mobile,
    required this.createdAt,
    required this.updatedAt,
  });
}
