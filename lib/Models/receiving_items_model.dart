// In a new file, e.g., models/item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String id;
  String companyId;
  String code;
  int quantity;
  double originalPrice;
  double vat;
  double discount;

  ItemModel({
    required this.id,
    required this.companyId,
    required this.code,
    required this.quantity,
    required this.originalPrice,
    required this.discount,
    required this.vat,
  });

  factory ItemModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ItemModel(
      id: doc.id,
      companyId: data['company_id'] as String,
      code: data['code'] as String,
      quantity: data['quantity'] as int,
      originalPrice: (data['orginal_price'] as num).toDouble(),
      vat: (data['vat'] as num).toDouble(),
      discount: (data['discount'] as num).toDouble(),
      
    );
  }
}