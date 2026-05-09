import 'package:DairyVikas/features/invoices/domain/repository/invoice_repo.dart';

class MarkUnpaidInvoiceUseCase {
  final InvoiceRepo invoiceRepo;

  MarkUnpaidInvoiceUseCase(this.invoiceRepo);

  Future<Map> call(Map params) {
    return invoiceRepo.markUnPaidInvoice(params);
  }
}
