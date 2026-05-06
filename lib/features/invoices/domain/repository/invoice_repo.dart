abstract class InvoiceRepo {
  // dealers metthods
  Future<Map> getAllInvoices(Map params);
  Future<Map> genrateInvoice(Map params);
  Future<Map> markPaidInvoice(Map params);
  Future<Map> deleteInvoice(String invoiceId);
  Future<Map> markUnPaidInvoice(Map params);
  Future<Map> getInvoiceDetails(Map params);
}
