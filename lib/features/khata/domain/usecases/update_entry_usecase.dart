import 'package:DairyVikas/features/khata/domain/repository/khata_repo.dart';

class UpdateEntryUsecase {
  final KhataRepo khataRepo;

  UpdateEntryUsecase(this.khataRepo);

  Future<Map> call(Map params) {
    return khataRepo.updateEntry(params);
  }
}
