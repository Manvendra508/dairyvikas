import 'package:dairysathi/features/khata/domain/repository/khata_repo.dart';

class GetEntriesByUserUsecase {
  final KhataRepo khataRepo;

  GetEntriesByUserUsecase(this.khataRepo);

  Future<Map> call(String userId) {
    return khataRepo.getAllEnteriesOfCustomer(userId);
  }
}
