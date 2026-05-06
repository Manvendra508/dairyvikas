import 'package:dairysathi/features/invoices/domain/repository/invoice_repo.dart';

class MarkPaidInvoiceUsecase {
  final InvoiceRepo invoiceRepo;

  MarkPaidInvoiceUsecase(this.invoiceRepo);

  Future<Map> call(Map params) {
    return invoiceRepo.markPaidInvoice(params);
  }
}
