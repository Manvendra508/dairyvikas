import '../repository/milk_supplier_repo.dart';

class DeleteMilkSupplierUsecase {
  final MilkSupplierRepo milkSupplierRepo;

  DeleteMilkSupplierUsecase(this.milkSupplierRepo);

  Future<Map> call(String supplierId) {
    return milkSupplierRepo.deleteMilkSupliers(supplierId);
  }
}
