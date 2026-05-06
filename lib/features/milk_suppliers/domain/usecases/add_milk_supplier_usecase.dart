import '../repository/milk_supplier_repo.dart';

class AddMilkSupplierUsecase {
  final MilkSupplierRepo milkSupplierRepo;

  AddMilkSupplierUsecase(this.milkSupplierRepo);

  Future<Map> call(Map supplierData) {
    return milkSupplierRepo.addMilkSupplier(supplierData);
  }
}
