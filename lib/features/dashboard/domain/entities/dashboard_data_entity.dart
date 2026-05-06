import 'package:dairysathi/features/auth/registration_flow/data/model/dairy_model.dart';
import 'package:dairysathi/features/dashboard/data/model/dashbaord_section_model.dart';

class DashboardDataEntity {
  final String daysLeftInFreeTrial;
  final List<DashbaordSectionModel> sections;
  final DairyModel? dairy;

  DashboardDataEntity({
    required this.sections,
    required this.daysLeftInFreeTrial,
    this.dairy,
  });
}
