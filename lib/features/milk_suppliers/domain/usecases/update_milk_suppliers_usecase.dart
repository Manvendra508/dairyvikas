import '../repository/milk_supplier_repo.dart';

class UpdateMilkSuppliersUsecase {
  final MilkSupplierRepo milkSupplierRepo;

  UpdateMilkSuppliersUsecase(this.milkSupplierRepo);

  Future<Map> call(Map supplierData) {
    return milkSupplierRepo.updateMilkSupplier(supplierData);
  }
}
