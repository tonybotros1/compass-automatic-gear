import 'car_trading_items_model.dart';

class CarTradeModel {
  String? id;
  String? status;
  int? mileage;
  List<CarTradingItemsModel>? tradeItems;
  DateTime? buyDate;
  DateTime? sellDate;
  double? totalPay;
  double? totalReceive;
  String? carBrandId;
  String? carBrand;
  String? carModelId;
  String? carModel;
  String? yearId;
  String? year;
  String? vin;
  String? colorInId;
  String? colorIn;
  String? colorOutId;
  String? colorOut;
  String? specificationId;
  String? specification;
  String? engineSizeId;
  String? engineSize;
  String? boughtFromId;
  String? boughtFrom;
  String? boughtBy;
  String? boughtById;
  String? soldToId;
  String? soldTo;
  String? soldBy;
  String? soldById;
  String? note;
  DateTime? date;
  double? net;
  DateTime? warrantyEndDate;
  DateTime? serviceContractEndDate;

  CarTradeModel({
    this.id,
    this.boughtFrom,
    this.soldTo,
    this.date,
    this.carBrand,
    this.carModel,
    this.mileage,
    this.specification,
    this.engineSize,
    this.colorIn,
    this.colorOut,
    this.year,
    this.note,
    this.status,
    this.tradeItems,
    this.buyDate,
    this.net,
    this.sellDate,
    this.boughtFromId,
    this.carBrandId,
    this.carModelId,
    this.colorInId,
    this.colorOutId,
    this.engineSizeId,
    this.soldToId,
    this.specificationId,
    this.totalPay,
    this.totalReceive,
    this.yearId,
    this.boughtBy,
    this.boughtById,
    this.soldBy,
    this.soldById,
    this.warrantyEndDate,
    this.serviceContractEndDate,
    this.vin,
  });

  DateTime? parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ??
        double.tryParse(value?.toString() ?? '')?.toInt() ??
        0;
  }

  CarTradeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? '';
    boughtFrom = json['bought_from']?.toString() ?? '';
    boughtFromId = json['bought_from_id']?.toString() ?? '';
    soldTo = json['sold_to']?.toString() ?? '';
    soldToId = json['sold_to_id']?.toString() ?? '';
    date = parseDate(json['date']?.toString());
    warrantyEndDate = json.containsKey('warranty_end_date')
        ? parseDate(json['warranty_end_date']?.toString())
        : null;
    serviceContractEndDate = json.containsKey('service_contract_end_date')
        ? parseDate(json['service_contract_end_date']?.toString())
        : null;
    buyDate = parseDate(json['buy_date']?.toString());
    sellDate = parseDate(json['sell_date']?.toString());
    carBrand = json['car_brand']?.toString() ?? '';
    carBrandId = json['car_brand_id']?.toString() ?? '';
    carModel = json['car_model']?.toString() ?? '';
    carModelId = json['car_model_id']?.toString() ?? '';
    mileage = _toInt(json['mileage']);
    specification = json['specification']?.toString() ?? '';
    specificationId = json['specification_id']?.toString() ?? '';
    engineSize = json['engine_size']?.toString() ?? '';
    engineSizeId = json['engine_size_id']?.toString() ?? '';
    colorIn = json['color_in']?.toString() ?? '';
    colorInId = json['color_in_id']?.toString() ?? '';
    colorOut = json['color_out']?.toString() ?? '';
    colorOutId = json['color_out_id']?.toString() ?? '';
    year = json['year']?.toString() ?? '';
    yearId = json['year_id']?.toString() ?? '';
    vin = json.containsKey('vin') ? json['vin']?.toString() ?? '' : '';
    note = json['note']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    soldBy = json.containsKey('sold_by')
        ? json['sold_by']?.toString() ?? ''
        : '';
    soldById = json.containsKey('sold_by_id')
        ? json['sold_by_id']?.toString() ?? ''
        : '';
    boughtBy = json.containsKey('bought_by')
        ? json['bought_by']?.toString() ?? ''
        : '';
    boughtById = json.containsKey('bought_by_id')
        ? json['bought_by_id']?.toString() ?? ''
        : '';
    totalPay = _toDouble(json['total_pay']);
    totalReceive = _toDouble(json['total_receive']);
    net = _toDouble(json['net']);

    // Parse trade items
    if (json['trade_items'] is List &&
        (json['trade_items'] as List).isNotEmpty) {
      tradeItems = <CarTradingItemsModel>[];
      for (final item in json['trade_items']) {
        if (item is Map) {
          tradeItems!.add(
            CarTradingItemsModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
  }
}
