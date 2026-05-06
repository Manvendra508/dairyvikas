import 'package:dairysathi/features/invoices/data/datasources/invoice_ds.dart';
import 'package:dairysathi/features/invoices/domain/repository/invoice_repo.dart';

class InvoiceRepoImpl implements InvoiceRepo {
  final InvoiceDs invoiceDs;

  InvoiceRepoImpl(this.invoiceDs);

  @override
  Future<Map> getAllInvoices(Map params) async {
    return await invoiceDs.getAllInVoices(params);
  }

  @override
  Future<Map> genrateInvoice(Map params) async {
    return await invoiceDs.genrateInvoice(params);
  }

  @override
  Future<Map> deleteInvoice(String invoiceId) async {
    return await invoiceDs.deleteInvoice(invoiceId);
  }

  @override
  Future<Map> markPaidInvoice(Map params) async {
    return await invoiceDs.markPaidInvoice(params);
  }

  @override
  Future<Map> markUnPaidInvoice(Map params) async {
    return await invoiceDs.markUnPaidInvoice(params);
  }

  @override
  Future<Map> getInvoiceDetails(Map params) async {
    return await invoiceDs.getInvoiceDetails(params);
  }

  // @override
  // Future<Map> getAllItems() async {
  //   return await foodDatasource.getAllItems();
  // }

  // @override
  // Future<Map> updateItem(String itemName, int itemId) async {
  //   return await foodDatasource.updateItem(itemName, itemId);
  // }

  // @override
  // Future<Map> addNewItem(String itemName) async {
  //   return await foodDatasource.addNewItem(itemName);
  // }

  // @override
  // Future<Map> addFoodStock(Map params) async {
  //   return await foodDatasource.addFoodStock(params);
  // }

  // @override
  // Future<Map> updateFoodStock(Map params) async {
  //   return await foodDatasource.updateFoodStock(params);
  // }

  // @override
  // Future<Map> getFoodStock(String dairyId) async {
  //   return await foodDatasource.getFoodStock(dairyId);
  // }

  // @override
  // Future<Map> addFoodSale(Map params) async {
  //   return await foodDatasource.addFoodSale(params);
  // }
}
