import 'package:dairysathi/features/invoices/domain/repository/invoice_repo.dart';

class GenrateInvoiceUsecase {
  final InvoiceRepo invoiceRepo;

  GenrateInvoiceUsecase(this.invoiceRepo);

  Future<Map> call(Map params) {
    return invoiceRepo.genrateInvoice(params);
  }
}
