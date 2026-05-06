import 'package:dairysathi/common/common_mixin.dart';
import 'package:dairysathi/features/rate_cart/domain/entities/increase_step_entity.dart';
import 'package:dairysathi/features/rate_cart/domain/entities/total_solid_step_entity.dart';
import 'package:get/get.dart';

class RateChartCommonFunctionController extends GetxController
    with CommonMixin {
  bool rangeValidationForFatandSnf(
    String fatFrom,
    String fatTo,
    String snfFrom,
    String snfTo,
    String rate,
    bool isFat,
  ) {
    if (isFat) {
      if (fatFrom.isEmpty || fatTo.isEmpty || rate.isEmpty) {
        showAppToastMessage('rate.fat_required'.tr, true);
        return false;
      } else {
        if (double.parse(fatFrom) < 2.0 || double.parse(fatTo) > 15.0) {
          showAppToastMessage('rate.fat_range'.tr, true);
          return false;
        }
      }
    } else {
      if (snfFrom.isEmpty || snfTo.isEmpty || rate.isEmpty) {
        showAppToastMessage('rate.snf_required'.tr, true);
        return false;
      } else {
        if (double.parse(snfFrom) < 4.0 || double.parse(snfTo) > 15.0) {
          showAppToastMessage('rate.snf_range'.tr, true);
          return false;
        }
      }
    }
    return true;
  }

  bool rangeValidationForFatandClr(
    String fatFrom,
    String fatTo,
    String clrFrom,
    String clrTo,
    String rate,
    bool isFat,
  ) {
    if (isFat) {
      if (fatFrom.isEmpty || fatTo.isEmpty || rate.isEmpty) {
        showAppToastMessage('rate.fat_required'.tr, true);
        return false;
      }
      if (double.parse(fatFrom) < 2.0 || double.parse(fatTo) > 15.0) {
        showAppToastMessage('rate.fat_range'.tr, true);
        return false;
      }
    } else {
      if (clrFrom.isEmpty || clrTo.isEmpty || rate.isEmpty) {
        showAppToastMessage('rate.clr_required'.tr, true);
        return false;
      }
      if (double.parse(clrFrom) < 20.0 || double.parse(clrTo) > 32.0) {
        showAppToastMessage('rate.clr_range'.tr, true);
        return false;
      }
    }
    return true;
  }

  bool fatSnfRangeValidate(
    String fatStep,
    String snfStep,
    bool isFatStep,
    String amount,
  ) {
    if (isFatStep) {
      if (fatStep.isEmpty || amount.isEmpty) {
        showAppToastMessage('rate.fat_step_required'.tr, true);
        return false;
      } else {
        if (double.parse(fatStep) < 2.0 || double.parse(fatStep) > 15.0) {
          showAppToastMessage('rate.fat_step_range'.tr, true);
          return false;
        }
      }
    } else {
      if (snfStep.isEmpty || amount.isEmpty) {
        showAppToastMessage('rate.snf_step_required'.tr, true);
        return false;
      } else {
        if (double.parse(snfStep) < 4.0 || double.parse(snfStep) > 15.0) {
          showAppToastMessage('rate.snf_step_range'.tr, true);
          return false;
        }
      }
    }
    return true;
  }

  bool fatClrRangeValidate(
    String fatStep,
    String clrStep,
    bool isFatStep,
    String amount,
  ) {
    if (isFatStep) {
      if (fatStep.isEmpty || amount.isEmpty) {
        showAppToastMessage('rate.fat_step_required'.tr, true);
        return false;
      } else {
        if (double.parse(fatStep) < 2.0 || double.parse(fatStep) > 15.0) {
          showAppToastMessage('rate.fat_step_range'.tr, true);
          return false;
        }
      }
    } else {
      if (clrStep.isEmpty || amount.isEmpty) {
        showAppToastMessage('rate.clr_step_required'.tr, true);
        return false;
      } else {
        if (double.parse(clrStep) < 20.0 || double.parse(clrStep) > 32.0) {
          showAppToastMessage('rate.clr_step_range'.tr, true);
          return false;
        }
      }
    }
    return true;
  }

  bool checkifStepIsDuplicateOrLess(
    bool isFatStep,
    List<IncreaseStep> fatSteps,
    List<IncreaseStep> snfSteps,
    String fatStepInput,
    String snfStepInput,
    bool isClrScreen,
  ) {
    if (isFatStep) {
      if (fatSteps.isNotEmpty) {
        final lastStepAdded = fatSteps.last.point;
        final stepInput = double.parse(fatStepInput);
        if (stepInput <= lastStepAdded) {
          showAppToastMessage(
            'rate.step_greater_than'.trParams({
              'type': 'Fat',
              'value': lastStepAdded.toString(),
            }),
            true,
          );
          return true;
        }
      }
    } else {
      if (snfSteps.isNotEmpty) {
        final lastStepAdded = snfSteps.last.point;
        final stepInput = double.parse(snfStepInput);
        if (stepInput <= lastStepAdded) {
          showAppToastMessage(
            'rate.step_greater_than'.trParams({
              'type': isClrScreen ? 'Clr' : 'Snf',
              'value': lastStepAdded.toString(),
            }),
            true,
          );
          return true;
        }
      }
    }
    return false;
  }

  bool checkifSolidStepIsDuplicateOrLess(
    List<TotalSolidStep> fatSteps,
    List<TotalSolidStep> snfSteps,
    String fatStepInput,
    String snfStepInput,
  ) {
    if (fatSteps.isNotEmpty) {
      final lastStepAdded = fatSteps.last.fatTo;
      final stepInput = double.parse(fatStepInput);
      if (stepInput <= lastStepAdded) {
        showAppToastMessage(
          'rate.step_greater_than'.trParams({
            'type': 'Fat',
            'value': lastStepAdded.toString(),
          }),
          true,
        );
        return true;
      }
    }

    if (snfSteps.isNotEmpty) {
      final lastStepAdded = snfSteps.last.snfOrclrTo;
      final stepInput = double.parse(snfStepInput);
      if (stepInput <= lastStepAdded) {
        showAppToastMessage(
          'rate.step_greater_than'.trParams({
            'type': 'Snf',
            'value': lastStepAdded.toString(),
          }),
          true,
        );
        return true;
      }
    }

    return false;
  }

  bool validateTotalSolid(
    String fatFrom,
    String fatTo,
    String snfFrom,
    String snfTo,
    String rate,
    bool isFatOnly,
  ) {
    if (isFatOnly) {
      if (fatFrom.isEmpty || fatTo.isEmpty || rate.isEmpty) {
        showAppToastMessage('rate.fat_required'.tr, true);
        return false;
      }
      if (double.parse(fatFrom) < 2.0 || double.parse(fatTo) > 15.0) {
        showAppToastMessage('rate.fat_range'.tr, true);
        return false;
      }
      return true;
    } else {
      if (fatFrom.isEmpty ||
          fatTo.isEmpty ||
          rate.isEmpty ||
          snfFrom.isEmpty ||
          snfTo.isEmpty) {
        showAppToastMessage('rate.fat_snf_required'.tr, true);
        return false;
      }
      if (double.parse(fatFrom) < 2.0 || double.parse(fatTo) > 15.0) {
        showAppToastMessage('rate.fat_range'.tr, true);
        return false;
      } else if (double.parse(snfFrom) < 4.0 || double.parse(snfTo) > 15.0) {
        showAppToastMessage('rate.snf_range'.tr, true);
        return false;
      }
      return true;
    }
  }

  String getRateChartTypeText(int chartType) {
    switch (chartType) {
      case 1:
        return 'FAT only';
      case 2:
        return 'CLR only';
      case 3:
        return 'FAT + SNF';
      case 4:
        return 'FAT + CLR';
      case 5:
        return 'FAT + CLR + Auto SNF';
      case 6:
        return '"Liter Only';
      default:
        return 'Unknown';
    }
  }
}
