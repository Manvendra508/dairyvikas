import 'package:DairyVikas/features/invoices/domain/repository/invoice_repo.dart';

class GetAllInvoicesUsecase {
  final InvoiceRepo invoiceRepo;

  GetAllInvoicesUsecase(this.invoiceRepo);

  Future<Map> call(Map params) {
    return invoiceRepo.getAllInvoices(params);
  }
}
