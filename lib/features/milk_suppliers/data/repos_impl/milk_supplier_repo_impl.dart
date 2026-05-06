import 'package:dairysathi/features/milk_suppliers/data/datasources/milk_supplier_ds.dart';

import '../../domain/repository/milk_supplier_repo.dart';

class MilkSupplierRepoImpl implements MilkSupplierRepo {
  final MilkSupplierDataSource milkSupplierDataSource;

  MilkSupplierRepoImpl(this.milkSupplierDataSource);
  @override
  Future<Map> addMilkSupplier(Map milkSupplierData) async {
    return await milkSupplierDataSource.addMilkSupplier(milkSupplierData);
  }

  @override
  Future<Map> updateMilkSupplier(Map milkSupplierData) async {
    return await milkSupplierDataSource.updateMilkSupplier(milkSupplierData);
  }

  @override
  Future<Map> getAllMilkSupliers(String dairyId) async {
    return await milkSupplierDataSource.getAllMilkSupliers(dairyId);
  }

  @override
  Future<Map> deleteMilkSupliers(String supplierId) async {
    return await milkSupplierDataSource.deleteMilkSupliers(supplierId);
  }

  @override
  Future<Map> updateSupplierStatus(Map milkSupplierData) async {
    return await milkSupplierDataSource.updateSupplierStatus(milkSupplierData);
  }
}
