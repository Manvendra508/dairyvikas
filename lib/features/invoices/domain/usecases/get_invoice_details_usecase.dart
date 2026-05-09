import 'package:DairyVikas/features/invoices/domain/repository/invoice_repo.dart';

class GetInvoiceDetailsUsecase {
  final InvoiceRepo invoiceRepo;

  GetInvoiceDetailsUsecase(this.invoiceRepo);

  Future<Map> call(Map params) {
    return invoiceRepo.getInvoiceDetails(params);
  }
}
