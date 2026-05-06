import 'package:dairysathi/features/khata/domain/repository/khata_repo.dart';

class DeleteKhatacustomerUsecase {
  final KhataRepo khataRepo;

  DeleteKhatacustomerUsecase(this.khataRepo);

  Future<Map> call(String userId) {
    return khataRepo.deleteKhataCustomer(userId);
  }
}
