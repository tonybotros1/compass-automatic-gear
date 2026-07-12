class VehicleAnalysisModel {
  int? carCount;
  double? buyPrice;
  double? sellPrice;
  double? totalPaid;
  double? totalReceived;
  double? expenses;
  double? revenue;
  String? brandId;
  String? brandName;
  double? buySellNet;
  double? expensesRevenueNet;
  double? totalNet;
  List<Cars>? cars;

  VehicleAnalysisModel({
    this.carCount,
    this.buyPrice,
    this.sellPrice,
    this.totalPaid,
    this.totalReceived,
    this.expenses,
    this.revenue,
    this.brandId,
    this.brandName,
    this.buySellNet,
    this.expensesRevenueNet,
    this.totalNet,
    this.cars,
  });

  factory VehicleAnalysisModel.fromJson(Map<String, dynamic> json) {
    return VehicleAnalysisModel(
      carCount: _readInt(json, 'car_count'),
      buyPrice: _readDouble(json, 'buy_price'),
      sellPrice: _readDouble(json, 'sell_price'),
      totalPaid: _readDouble(json, 'total_paid'),
      totalReceived: _readDouble(json, 'total_received'),
      expenses: _readDouble(json, 'expenses'),
      revenue: _readDouble(json, 'revenue'),
      brandId: _readString(json, 'brand_id'),
      brandName: _readString(json, 'brand_name'),
      buySellNet: _readDouble(json, 'buy_sell_net'),
      expensesRevenueNet: _readDouble(json, 'expenses_revenue_net'),
      totalNet: _readDouble(json, 'total_net'),
      cars: _readCars(json),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (carCount != null) {
      data['car_count'] = carCount;
    }

    if (buyPrice != null) {
      data['buy_price'] = buyPrice;
    }

    if (sellPrice != null) {
      data['sell_price'] = sellPrice;
    }

    if (totalPaid != null) {
      data['total_paid'] = totalPaid;
    }

    if (totalReceived != null) {
      data['total_received'] = totalReceived;
    }

    if (expenses != null) {
      data['expenses'] = expenses;
    }

    if (revenue != null) {
      data['revenue'] = revenue;
    }

    if (brandId != null) {
      data['brand_id'] = brandId;
    }

    if (brandName != null) {
      data['brand_name'] = brandName;
    }

    if (buySellNet != null) {
      data['buy_sell_net'] = buySellNet;
    }

    if (expensesRevenueNet != null) {
      data['expenses_revenue_net'] = expensesRevenueNet;
    }

    if (totalNet != null) {
      data['total_net'] = totalNet;
    }

    if (cars != null) {
      data['cars'] = cars!.map((Cars car) => car.toJson()).toList();
    }

    return data;
  }

  static List<Cars>? _readCars(Map<String, dynamic> json) {
    if (!json.containsKey('cars') || json['cars'] == null) {
      return null;
    }

    final dynamic value = json['cars'];

    if (value is! List) {
      return null;
    }

    return value
        .whereType<Map>()
        .map((Map carJson) => Cars.fromJson(Map<String, dynamic>.from(carJson)))
        .toList();
  }
}

class Cars {
  String? carId;
  String? brandId;
  String? brandName;
  String? modelId;
  String? modelName;
  String? trim;
  double? buyPrice;
  double? sellPrice;
  double? buySellNet;
  double? expenses;
  double? revenue;
  double? expensesRevenueNet;
  double? totalPaid;
  double? totalReceived;
  double? totalNet;

  Cars({
    this.carId,
    this.brandId,
    this.brandName,
    this.modelId,
    this.modelName,
    this.trim,
    this.buyPrice,
    this.sellPrice,
    this.buySellNet,
    this.expenses,
    this.revenue,
    this.expensesRevenueNet,
    this.totalPaid,
    this.totalReceived,
    this.totalNet,
  });

  factory Cars.fromJson(Map<String, dynamic> json) {
    return Cars(
      carId: _readString(json, 'car_id'),
      brandId: _readString(json, 'brand_id'),
      brandName: _readString(json, 'brand_name'),
      modelId: _readString(json, 'model_id'),
      modelName: _readString(json, 'model_name'),
      trim: _readString(json, 'trim'),
      buyPrice: _readDouble(json, 'buy_price'),
      sellPrice: _readDouble(json, 'sell_price'),
      buySellNet: _readDouble(json, 'buy_sell_net'),
      expenses: _readDouble(json, 'expenses'),
      revenue: _readDouble(json, 'revenue'),
      expensesRevenueNet: _readDouble(json, 'expenses_revenue_net'),
      totalPaid: _readDouble(json, 'total_paid'),
      totalReceived: _readDouble(json, 'total_received'),
      totalNet: _readDouble(json, 'total_net'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (carId != null) {
      data['car_id'] = carId;
    }

    if (brandId != null) {
      data['brand_id'] = brandId;
    }

    if (brandName != null) {
      data['brand_name'] = brandName;
    }

    if (modelId != null) {
      data['model_id'] = modelId;
    }

    if (modelName != null) {
      data['model_name'] = modelName;
    }

    if (trim != null) {
      data['trim'] = trim;
    }

    if (buyPrice != null) {
      data['buy_price'] = buyPrice;
    }

    if (sellPrice != null) {
      data['sell_price'] = sellPrice;
    }

    if (buySellNet != null) {
      data['buy_sell_net'] = buySellNet;
    }

    if (expenses != null) {
      data['expenses'] = expenses;
    }

    if (revenue != null) {
      data['revenue'] = revenue;
    }

    if (expensesRevenueNet != null) {
      data['expenses_revenue_net'] = expensesRevenueNet;
    }

    if (totalPaid != null) {
      data['total_paid'] = totalPaid;
    }

    if (totalReceived != null) {
      data['total_received'] = totalReceived;
    }

    if (totalNet != null) {
      data['total_net'] = totalNet;
    }

    return data;
  }
}

/// Reads an integer safely.
///
/// Supports:
/// - int
/// - double
/// - numeric String
///
/// Returns null when the key does not exist or the value cannot be parsed.
int? _readInt(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key) || json[key] == null) {
    return null;
  }

  final dynamic value = json[key];

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString());
}

/// Reads a double safely.
///
/// Supports:
/// - int
/// - double
/// - numeric String
///
/// Returns null when the key does not exist or the value cannot be parsed.
double? _readDouble(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key) || json[key] == null) {
    return null;
  }

  final dynamic value = json[key];

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

/// Reads a String safely.
///
/// Returns null when:
/// - The key does not exist.
/// - The value is null.
/// - The resulting String is empty.
String? _readString(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key) || json[key] == null) {
    return null;
  }

  final String value = json[key].toString().trim();

  if (value.isEmpty) {
    return null;
  }

  return value;
}
