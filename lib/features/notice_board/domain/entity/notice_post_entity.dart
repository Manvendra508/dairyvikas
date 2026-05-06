class NoticeEntity {
  final int id;
  final int dairyId;
  final String notice;
  final DateTime? scheduleDate;
  final DateTime? expiryDate;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final String status;
  // final NoticeFlagsEntity flags;

  NoticeEntity({
    required this.id,
    required this.dairyId,
    required this.notice,
    this.scheduleDate,
    this.expiryDate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    // required this.status,
    // required this.flags,
  });
}

class NoticeFlagsEntity {
  final bool isScheduled;
  final bool isActive;
  final bool isExpired;

  NoticeFlagsEntity({
    required this.isScheduled,
    required this.isActive,
    required this.isExpired,
  });
}
