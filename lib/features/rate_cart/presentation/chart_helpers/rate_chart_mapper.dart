import '../../domain/entities/bonus_penality_step_entity.dart';
import '../../domain/entities/rate_step_entity.dart';

/// ===============================
/// RATE CHART REVERSE MAPPER
/// ===============================
class RateChartMapper {
  /// Outputs
  List<double> fatValues = [];
  List<double>? snfValues;
  List<double>? clrValues;
  List<List<double>> rateChart = [];

  List<BonusPenaltyStep> fatBonus = [];
  List<BonusPenaltyStep> snfBonus = [];

  List<RateStep> fatSteps = [];
  List<RateStep> snfSteps = [];
  List<RateStep> clrSteps = [];

  /// ===============================
  /// MAIN ENTRY
  /// ===============================
  void rebuildFromRateRows(
    List<Map<String, dynamic>> rateRows,
    bool isStepsNotNull,
  ) {
    _extractAxisValues(rateRows);
    if (isStepsNotNull) {
      _rebuildRateSteps(rateRows); // 👈 NEW
    }
    _createEmptyMatrix();
    _fillRateMatrix(rateRows);
    _rebuildBonusPenalties(rateRows);
  }

  /// ===============================
  /// 1️⃣ Extract FAT / SNF / CLR
  /// ===============================
  void _extractAxisValues(List<Map<String, dynamic>> rateRows) {
    final Set<double> fatSet = {};
    final Set<double> snfSet = {};
    final Set<double> clrSet = {};

    for (final row in rateRows) {
      fatSet.add((row['fat'] as num).toDouble());

      if (row['snf'] != null) {
        snfSet.add((row['snf'] as num).toDouble());
      }

      if (row['clr'] != null) {
        clrSet.add((row['clr'] as num).toDouble());
      }
    }

    fatValues = fatSet.toList()..sort();
    snfValues = (snfSet.isEmpty ? null : snfSet.toList());
    clrValues = (clrSet.isEmpty ? null : clrSet.toList());
    if (snfValues != null) {
      snfValues!.sort();
    }
    if (clrValues != null) {
      clrValues!.sort();
    }
  }

  /// ===============================
  /// 2️⃣ Create Empty Matrix
  /// ===============================
  void _createEmptyMatrix() {
    final int rows = fatValues.length;
    final int cols = snfValues?.length ?? clrValues?.length ?? 1;

    rateChart = List.generate(rows, (_) => List.filled(cols, 0.0));
  }

  /// ===============================
  /// 3️⃣ Fill Price Matrix
  /// ===============================
  void _fillRateMatrix(List<Map<String, dynamic>> rateRows) {
    for (final row in rateRows) {
      final double fat = (row['fat'] as num).toDouble();
      final double price = (row['price'] as num).toDouble();

      final int rowIndex = fatValues.indexOf(fat);
      int colIndex = 0;

      if (snfValues != null && row.containsKey('snf')) {
        colIndex = snfValues!.indexOf((row['snf'] as num).toDouble());
      } else if (clrValues != null && row.containsKey('clr')) {
        colIndex = clrValues!.indexOf((row['clr'] as num).toDouble());
      }

      rateChart[rowIndex][colIndex] = price;
    }
  }

  /// ===============================
  /// 4️⃣ Rebuild Bonus / Penalty
  /// ===============================
  void _rebuildBonusPenalties(List<Map<String, dynamic>> rateRows) {
    fatBonus = _rebuildBonusSlabs(rateRows, 'fat');

    if (snfValues != null) {
      snfBonus = _rebuildBonusSlabs(rateRows, 'snf');
    }
  }

  /// 5️⃣ Bonus Slab Builder
  /// ===============================
  List<BonusPenaltyStep> _rebuildBonusSlabs(
    List<Map<String, dynamic>> rateRows,
    String key,
  ) {
    final Map<double, double> valueToDelta = {};

    for (final row in rateRows) {
      if (!row.containsKey(key)) continue;

      final double value = (row[key] as num).toDouble();
      final double bonus = (row['bonus'] as num?)?.toDouble() ?? 0;
      final double penalty = (row['penalty'] as num?)?.toDouble() ?? 0;

      valueToDelta[value] = bonus - penalty;
    }

    final sortedKeys = valueToDelta.keys.toList()..sort();
    final List<BonusPenaltyStep> steps = [];

    double? rangeStart;
    double? currentAmount;

    for (final val in sortedKeys) {
      final double delta = valueToDelta[val]!;

      if (delta == 0) {
        rangeStart = null;
        currentAmount = null;
        continue;
      }

      if (currentAmount == delta) continue;

      if (rangeStart != null && currentAmount != null) {
        steps.add(
          BonusPenaltyStep(
            start: rangeStart,
            end: val,
            amount: currentAmount.abs(),
            isBonus: currentAmount > 0,
          ),
        );
      }

      rangeStart = val;
      currentAmount = delta;
    }

    if (rangeStart != null && currentAmount != null) {
      steps.add(
        BonusPenaltyStep(
          start: rangeStart,
          end: sortedKeys.last,
          amount: currentAmount.abs(),
          isBonus: currentAmount > 0,
        ),
      );
    }

    return steps;
  }

  void _rebuildRateSteps(List<Map<String, dynamic>> rateRows) {
    fatSteps = _buildRateSteps(rateRows, axisKey: 'fat');
    if (snfValues != null) {
      snfSteps = _buildRateSteps(rateRows, axisKey: 'snf');
    }
    if (clrValues != null) {
      clrSteps = _buildRateSteps(rateRows, axisKey: 'clr');
    }
  }

  List<RateStep> _buildRateSteps(
    List<Map<String, dynamic>> rateRows, {
    required String axisKey,
  }) {
    /// Map<axisValue, ratePaisa>
    final Map<double, double> valueToRate = {};

    for (final row in rateRows) {
      if (!row.containsKey(axisKey)) continue;

      final double axisValue = (row[axisKey] as num).toDouble();
      final double rate = (row['price'] as num).toDouble();

      valueToRate[axisValue] = rate;
    }

    final sortedValues = valueToRate.keys.toList()..sort();
    final List<RateStep> steps = [];

    double? rangeStart;
    double? currentRate;

    for (final value in sortedValues) {
      final rate = valueToRate[value]!;

      if (currentRate == null) {
        rangeStart = value;
        currentRate = rate;
        continue;
      }

      /// rate changed → close previous slab
      if (rate != currentRate) {
        steps.add(
          RateStep(start: rangeStart!, end: value, ratePaisa: currentRate),
        );
        rangeStart = value;
        currentRate = rate;
      }
    }

    /// Close last slab
    if (rangeStart != null && currentRate != null) {
      steps.add(
        RateStep(
          start: rangeStart,
          end: sortedValues.last,
          ratePaisa: currentRate,
        ),
      );
    }

    return steps;
  }
}

// uses of this class

// final mapper = RateChartMapper();

// mapper.rebuildFromRateRows(apiRateRows);

// fatValues = mapper.fatValues;
// snfValues = mapper.snfValues;
// clrValues = mapper.clrValues;
// rateChart = mapper.rateChart;
// fatBonus = mapper.fatBonus;
// snfBonus = mapper.snfBonus;
