import 'package:DairyVikas/features/auth/registration_flow/data/model/dairy_model.dart';

class AddDairyResponseEntity {
  final bool success;
  final String message;
  final DairyModel dairyModel;

  AddDairyResponseEntity({
    required this.success,
    required this.message,
    required this.dairyModel,
  });
}
