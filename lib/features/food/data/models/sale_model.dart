import '../../domain/entity/sale_entity.dart';

class SaleModel extends SaleEntity {
  const SaleModel({
    required super.id,
    required super.dairyId,
    required super.itemId,
    required super.quantity,
    required super.sellingPrice,
    required super.saleDate,
    super.buyerId,
    super.supplierId,
    required super.createdAt,
    required super.updatedAt,
    required super.saleItemDetails,
    super.saleBuyer,
    super.saleSupplier,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? 0,
      dairyId: json['dairy_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      saleDate: json['sale_date'] ?? '',
      buyerId: json['buyer_id'],
      supplierId: json['supplier_id'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      saleItemDetails: SaleItemDetailsModel.fromJson(json['sale_item_details']),
      saleBuyer: json['sale_buyer'] != null
          ? SaleBuyerModel.fromJson(json['sale_buyer'])
          : null,
      saleSupplier: json['sale_supplier'] != null
          ? SaleSupplierModel.fromJson(json['sale_supplier'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dairy_id': dairyId,
      'item_id': itemId,
      'quantity': quantity,
      'selling_price': sellingPrice,
      'sale_date': saleDate,
      'buyer_id': buyerId,
      'supplier_id': supplierId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sale_item_details': (saleItemDetails as SaleItemDetailsModel?)?.toJson(),
      'sale_buyer': (saleBuyer as SaleBuyerModel?)?.toJson(),
      'sale_supplier': (saleSupplier as SaleSupplierModel?)?.toJson(),
    };
  }

  factory SaleModel.empty() {
    return SaleModel(
      id: 0,
      dairyId: 0,
      itemId: 0,
      quantity: 0,
      sellingPrice: 0,
      saleDate: '',
      buyerId: null,
      supplierId: null,
      createdAt: '',
      updatedAt: '',
      saleItemDetails: SaleItemDetailsModel.empty(),
      saleBuyer: null,
      saleSupplier: null,
    );
  }
}

class SaleItemDetailsModel extends SaleItemDetailsEntity {
  const SaleItemDetailsModel({required super.id, required super.itemName});

  factory SaleItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaleItemDetailsModel(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? '',
    );
  }

  factory SaleItemDetailsModel.empty() {
    return SaleItemDetailsModel(id: 0, itemName: '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'item_name': itemName};
  }
}

class SaleBuyerModel extends SaleBuyerEntity {
  const SaleBuyerModel({
    required super.id,
    required super.buyerName,
    required super.buyerCode,
  });

  factory SaleBuyerModel.fromJson(Map<String, dynamic> json) {
    return SaleBuyerModel(
      id: json['id'] ?? 0,
      buyerName: json['buyer_name'] ?? '',
      buyerCode: json['milk_buyer_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'buyer_name': buyerName};
  }
}

class SaleSupplierModel extends SaleSupplierEntity {
  const SaleSupplierModel({
    required super.id,
    required super.supplierName,
    required super.supplierCode,
  });

  factory SaleSupplierModel.fromJson(Map<String, dynamic> json) {
    return SaleSupplierModel(
      id: json['id'] ?? 0,
      supplierName: json['supplier_name'] ?? '',
      supplierCode: json['milk_supplier_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'supplier_name': supplierName};
  }
}
