import '../../domain/entity/notice_post_entity.dart';

class NoticeModel extends NoticeEntity {
  NoticeModel({
    required super.id,
    required super.dairyId,
    required super.notice,
    super.scheduleDate,
    super.expiryDate,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    super.updatedAt,
    // required super.status,
    // required super.flags,
  });

  /// 🔹 From JSON
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      dairyId: json['dairy_id'] ?? 0,
      notice: json['notice'] ?? '',
      scheduleDate: json['schedule_date'] != null
          ? DateTime.parse(json['schedule_date'])
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      // status: json['status'] ?? '',
      // flags: NoticeFlagsModel.fromJson(json['flags'] ?? {}),
    );
  }

  /// 🔹 To JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dairy_id": dairyId,
      "notice": notice,
      "schedule_date": scheduleDate?.toIso8601String(),
      "expiry_date": expiryDate?.toIso8601String(),
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      // "status": status,
      // "flags": (flags as NoticeFlagsModel).toJson(),
    };
  }

  /// 🔹 Empty Method
  factory NoticeModel.empty() {
    return NoticeModel(
      id: 0,
      dairyId: 0,
      notice: '',
      scheduleDate: null,
      expiryDate: null,
      createdBy: null,
      updatedBy: null,
      createdAt: null,
      updatedAt: null,
      // status: '',
      // flags: NoticeFlagsModel.empty(),
    );
  }
}

/// 🔸 Flags Model
class NoticeFlagsModel extends NoticeFlagsEntity {
  NoticeFlagsModel({
    required super.isScheduled,
    required super.isActive,
    required super.isExpired,
  });

  factory NoticeFlagsModel.fromJson(Map<String, dynamic> json) {
    return NoticeFlagsModel(
      isScheduled: json['isScheduled'] ?? false,
      isActive: json['isActive'] ?? false,
      isExpired: json['isExpired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isScheduled": isScheduled,
      "isActive": isActive,
      "isExpired": isExpired,
    };
  }

  factory NoticeFlagsModel.empty() {
    return NoticeFlagsModel(
      isScheduled: false,
      isActive: false,
      isExpired: false,
    );
  }
}
