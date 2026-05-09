import 'package:DairyVikas/features/khata/domain/repository/khata_repo.dart';

class DeleteEntryUsecase {
  final KhataRepo khataRepo;

  DeleteEntryUsecase(this.khataRepo);

  Future<Map> call(String userId) {
    return khataRepo.deleteEntry(userId);
  }
}
