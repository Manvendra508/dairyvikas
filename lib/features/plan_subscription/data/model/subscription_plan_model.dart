import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.validityDays,
    required super.price,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.metaData,
    required super.isBestValue,
  });

  /// 🔥 FROM JSON
  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: _parseDescription(json['description']),
      validityDays: json['validity_days'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metaData: _parseDescription(json['meta']),
      isBestValue: json['best_value'] ?? false,
    );
  }

  /// 🔥 TO JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": jsonEncode(description),
      "validity_days": validityDays,
      "price": price,
      "is_active": isActive,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  /// 🔥 Empty model
  factory SubscriptionPlanModel.empty() {
    return SubscriptionPlanModel(
      id: 0,
      name: '',
      description: {},
      validityDays: 0,
      price: 0.0,
      isActive: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      metaData: {},
      isBestValue: false,
    );
  }

  /// 🔥 Helper to parse description string → Map
  static Map<String, String> _parseDescription(dynamic desc) {
    if (desc == null) return {};

    try {
      if (desc is String) {
        final decoded = jsonDecode(desc);
        return Map<String, String>.from(
          decoded.map((key, value) => MapEntry(key, value.toString())),
        );
      }

      if (desc is Map) {
        return Map<String, String>.from(
          desc.map((key, value) => MapEntry(key, value.toString())),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Parse Error: $e");
      }
    }

    return {};
  }
}
