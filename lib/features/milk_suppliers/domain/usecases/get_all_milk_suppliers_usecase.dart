import '../repository/milk_supplier_repo.dart';

class GetAllMilkSuppliersUsecase {
  final MilkSupplierRepo milkSupplierRepo;

  GetAllMilkSuppliersUsecase(this.milkSupplierRepo);

  Future<Map> call(String dairyId) {
    return milkSupplierRepo.getAllMilkSupliers(dairyId);
  }
}
