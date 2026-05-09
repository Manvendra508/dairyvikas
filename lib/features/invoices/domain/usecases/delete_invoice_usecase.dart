import 'package:DairyVikas/features/invoices/domain/repository/invoice_repo.dart';

class DeleteInvoiceUsecase {
  final InvoiceRepo invoiceRepo;

  DeleteInvoiceUsecase(this.invoiceRepo);

  Future<Map> call(String invoiceId) {
    return invoiceRepo.deleteInvoice(invoiceId);
  }
}
