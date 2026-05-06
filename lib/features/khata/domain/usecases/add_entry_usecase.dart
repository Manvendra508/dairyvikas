import 'package:dairysathi/features/khata/domain/repository/khata_repo.dart';

class AddEntryUsecase {
  final KhataRepo khataRepo;

  AddEntryUsecase(this.khataRepo);

  Future<Map> call(Map params) {
    return khataRepo.addEntry(params);
  }
}
