import 'dart:convert';

import 'package:dairysathi/features/rate_cart/domain/entities/increase_step_entity.dart';
import 'package:dairysathi/features/rate_cart/domain/entities/rate_step_entity.dart';
import 'package:dairysathi/features/rate_cart/domain/entities/total_solid_step_entity.dart';

class AddUpdateChartControllerHelper {
  static List<List<dynamic>> parseStepsFromJson(
    String jsonString,
    String formateid,
  ) {
    final Map<String, dynamic> map = jsonDecode(jsonString);

    if (formateid == '1') {
      return _parseRatePerKg(map);
    }

    if (formateid == '2') {
      return _parseIncreasePerPoint(map);
    }

    if (formateid == '3') {
      return _parseTotalSolid(map);
    }

    return [];
  }

  static List<List<RateStep>> _parseRatePerKg(Map<String, dynamic> map) {
    List<List<RateStep>> result = [];

    if (map.containsKey('fat')) {
      result.add(
        (map['fat'] as List)
            .map(
              (e) => RateStep(
                start: (e['start'] as num).toDouble(),
                end: (e['end'] as num).toDouble(),
                ratePaisa: (e['price'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    }

    if (map.containsKey('snf')) {
      result.add(
        (map['snf'] as List)
            .map(
              (e) => RateStep(
                start: (e['start'] as num).toDouble(),
                end: (e['end'] as num).toDouble(),
                ratePaisa: (e['price'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    }

    if (map.containsKey('clr')) {
      result.add(
        (map['clr'] as List)
            .map(
              (e) => RateStep(
                start: (e['start'] as num).toDouble(),
                end: (e['end'] as num).toDouble(),
                ratePaisa: (e['price'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    }

    return result;
  }

  static List<List<IncreaseStep>> _parseIncreasePerPoint(
    Map<String, dynamic> map,
  ) {
    List<List<IncreaseStep>> result = [];

    List<IncreaseStep> parseAxis(String key) => (map[key] as List)
        .map(
          (e) => IncreaseStep(
            point: (e['point'] as num).toDouble(),
            amount: (e['price'] as num).toDouble(),
          ),
        )
        .toList();

    if (map.containsKey('fat')) result.add(parseAxis('fat'));
    if (map.containsKey('snf')) result.add(parseAxis('snf'));
    if (map.containsKey('clr')) result.add(parseAxis('clr'));

    return result;
  }

  static List<List<TotalSolidStep>> _parseTotalSolid(Map<String, dynamic> map) {
    List<List<TotalSolidStep>> result = [];

    List<TotalSolidStep> parseAxis(String key, bool isFat) => (map[key] as List)
        .map(
          (e) => TotalSolidStep(
            fatFrom: isFat ? (e['start'] as num).toDouble() : 0,
            fatTo: isFat ? (e['end'] as num).toDouble() : 0,
            snfOrclrFrom: !isFat ? (e['start'] as num).toDouble() : 0,
            snfOrclrTo: !isFat ? (e['end'] as num).toDouble() : 0,
            rate: (e['price'] as num).toDouble(),
          ),
        )
        .toList();

    if (map.containsKey('fat')) {
      result.add(parseAxis('fat', true));
    }
    if (map.containsKey('snf')) {
      result.add(parseAxis('snf', false));
    }
    if (map.containsKey('clr')) {
      result.add(parseAxis('clr', false));
    }

    return result;
  }
}
