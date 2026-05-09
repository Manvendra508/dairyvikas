import 'package:DairyVikas/features/khata/data/datasources/khata_datasource.dart';

import '../../domain/repository/khata_repo.dart';

class KhataRepoImpl implements KhataRepo {
  final KhataDatasource khataDatasource;

  KhataRepoImpl(this.khataDatasource);
  @override
  Future<Map> addKhataCustomer(Map params) async {
    return await khataDatasource.addKhataCustomer(params);
  }

  @override
  Future<Map> updateKhataCustomer(Map params) async {
    return await khataDatasource.updateKhataCustomer(params);
  }

  @override
  Future<Map> deleteKhataCustomer(String userId) async {
    return await khataDatasource.deleteKhataCustomer(userId);
  }

  @override
  Future<Map> getAllKhataBookCustomers(String dairyId) async {
    return await khataDatasource.getAllKhataBookCustomers(dairyId);
  }

  @override
  Future<Map> addEntry(Map params) async {
    return await khataDatasource.addEntry(params);
  }

  @override
  Future<Map> deleteEntry(String userId) async {
    return await khataDatasource.deleteEntry(userId);
  }

  @override
  Future<Map> getAllEnteriesOfCustomer(String userId) async {
    return await khataDatasource.getAllEntriesByCustomerId(userId);
  }

  @override
  Future<Map> updateEntry(Map params) async {
    return await khataDatasource.updateEntry(params);
  }
}
