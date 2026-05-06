import '../../data/model/collection_can_model.dart';

class MilkCollectionEntity {
  final int wScale;
  final int totalLiter;
  final int numberOfCans;
  final List<CanStepModel> steps;

  const MilkCollectionEntity({
    required this.wScale,
    required this.totalLiter,
    required this.numberOfCans,
    required this.steps,
  });

  factory MilkCollectionEntity.empty() {
    return const MilkCollectionEntity(
      wScale: 0,
      totalLiter: 0,
      numberOfCans: 0,
      steps: [],
    );
  }
}

class CanStepEntity {
  final int canNumber;
  final int canLiter;

  const CanStepEntity({required this.canNumber, required this.canLiter});

  factory CanStepEntity.empty() {
    return const CanStepEntity(canNumber: 0, canLiter: 0);
  }
}
