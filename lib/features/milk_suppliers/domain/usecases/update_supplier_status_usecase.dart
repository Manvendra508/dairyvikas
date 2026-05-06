import '../repository/milk_supplier_repo.dart';

class UpdateSupplierStatusUsecase {
  final MilkSupplierRepo milkSupplierRepo;

  UpdateSupplierStatusUsecase(this.milkSupplierRepo);

  Future<Map> call(Map supplierData) {
    return milkSupplierRepo.updateSupplierStatus(supplierData);
  }
}
