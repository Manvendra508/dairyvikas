import 'package:DairyVikas/features/khata/domain/repository/khata_repo.dart';

class UpdateKhatacustomerUsecase {
  final KhataRepo khataRepo;

  UpdateKhatacustomerUsecase(this.khataRepo);

  Future<Map> call(Map params) {
    return khataRepo.updateKhataCustomer(params);
  }
}
