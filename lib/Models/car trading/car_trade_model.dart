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
  });

  DateTime? parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  CarTradeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    boughtFrom = json['bought_from'] ?? '';
    boughtFromId = json['bought_from_id'] ?? '';
    soldTo = json['sold_to'] ?? '';
    soldToId = json['sold_to_id'] ?? '';
    date = parseDate(json['date']);
    buyDate = parseDate(json['buy_date']);
    sellDate = parseDate(json['sell_date']);
    carBrand = json['car_brand'] ?? '';
    carBrandId = json['car_brand_id'] ?? '';
    carModel = json['car_model'] ?? '';
    carModelId = json['car_model_id'] ?? '';
    mileage = (json['mileage'] is num) ? (json['mileage'] as num).toInt() : 0;
    specification = json['specification'] ?? '';
    specificationId = json['specification_id'] ?? '';
    engineSize = json['engine_size'] ?? '';
    engineSizeId = json['engine_size_id'] ?? '';
    colorIn = json['color_in'] ?? '';
    colorInId = json['color_in_id'] ?? '';
    colorOut = json['color_out'] ?? '';
    colorOutId = json['color_out_id'] ?? '';
    year = json['year'] ?? '';
    yearId = json['year_id'] ?? '';
    note = json['note'] ?? '';
    status = json['status'] ?? '';
    soldBy = json.containsKey('sold_by') ? json['sold_by'] ?? '' : '';
    soldById = json.containsKey('sold_by_id') ? json['sold_by_id'] ?? '' : '';
    boughtBy = json.containsKey('bought_by') ? json['bought_by'] ?? '' : '';
    boughtById = json.containsKey('bought_by_id') ? json['bought_by_id'] ?? '' : '';
    totalPay = (json['total_pay'] is num)
        ? (json['total_pay'] as num).toDouble()
        : 0;

    totalReceive = (json['total_receive'] is num)
        ? (json['total_receive'] as num).toDouble()
        : 0;

    net = (json['net'] is num) ? (json['net'] as num).toDouble() : 0;

    // Parse trade items
    if (json['trade_items'] != null &&
        (json['trade_items'] as List).isNotEmpty) {
      tradeItems = <CarTradingItemsModel>[];
      json['trade_items'].forEach((v) {
        tradeItems!.add(CarTradingItemsModel.fromJson(v));
      });
    }
  }
}
