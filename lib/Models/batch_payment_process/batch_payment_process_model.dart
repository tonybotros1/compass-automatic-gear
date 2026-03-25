class BatchPaymentProcessModel {
  final String? id;
  final String? batchNumber;
  final DateTime? batchDate;
  final String? note;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BatchPaymentProcessModel({
    this.id,
    this.batchNumber,
    this.batchDate,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BatchPaymentProcessModel.fromJson(Map<String, dynamic> json) {
    return BatchPaymentProcessModel(
      id: json['_id'] ?? '',
      batchNumber: json['batch_number'] ?? '',
      batchDate: json.containsKey('batch_date')
          ? DateTime.tryParse(json['batch_date'])
          : null,
      note: json['note'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
