import 'package:DairyVikas/features/khata/domain/repository/khata_repo.dart';

class AddKhataCustomerUsecase {
  final KhataRepo khataRepo;

  AddKhataCustomerUsecase(this.khataRepo);

  Future<Map> call(Map params) {
    return khataRepo.addKhataCustomer(params);
  }
}
