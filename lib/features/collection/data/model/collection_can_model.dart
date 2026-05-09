import 'package:DairyVikas/features/collection/domain/entities/collection_can_entity.dart';

class MilkCollectionCanModel extends MilkCollectionEntity {
  const MilkCollectionCanModel({
    required super.wScale,
    required super.totalLiter,
    required super.numberOfCans,
    required super.steps,
  });

  factory MilkCollectionCanModel.fromJson(Map<String, dynamic> json) {
    return MilkCollectionCanModel(
      wScale: json['w-scale'] ?? 0,
      totalLiter: json['totalLiter'] ?? 0,
      numberOfCans: json['numberOfCans'] ?? 0,
      steps: (json['steps'] as List<dynamic>? ?? [])
          .map((e) => CanStepModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "w-scale": wScale,
      "totalLiter": totalLiter,
      "numberOfCans": numberOfCans,
      "steps": steps.map((e) => (e).toJson()).toList(),
    };
  }

  factory MilkCollectionCanModel.empty() {
    return MilkCollectionCanModel(
      wScale: 0,
      totalLiter: 0,
      numberOfCans: 0,
      steps: <CanStepModel>[],
    );
  }
}

class CanStepModel extends CanStepEntity {
  const CanStepModel({required super.canNumber, required super.canLiter});

  factory CanStepModel.fromJson(Map<String, dynamic> json) {
    return CanStepModel(
      canNumber: json['canNumber'] ?? 0,
      canLiter: json['canLiter'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"canNumber": canNumber, "canLiter": canLiter};
  }

  factory CanStepModel.empty() {
    return const CanStepModel(canNumber: 0, canLiter: 0);
  }
}
