import 'package:dairysathi/features/khata/domain/repository/khata_repo.dart';

class GetKhatabookCustomersUseCase {
  final KhataRepo khataRepo;

  GetKhatabookCustomersUseCase(this.khataRepo);

  Future<Map> call(String dairyId) {
    return khataRepo.getAllKhataBookCustomers(dairyId);
  }
}
