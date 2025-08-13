class ReceivingItemsModel {
  final int quantity;
  final double orginalPrice;
  final double discount;
  final double vat;
  final double rate;
  final double totalForAllItems;
  final double handling;
  final double other;
  final double shipping;
  final double amount;
  

  ReceivingItemsModel({
    required this.amount,
    required this.handling,
    required this.other,
    required this.shipping,
    required this.quantity,
    required this.orginalPrice,
    required this.discount,
    required this.vat,
    required this.rate,
    required this.totalForAllItems,
  });

  double safeNumber(double number) {
    if (number.isNaN || number.isInfinite) return 0;
    return number;
  }

  double get addCost {
    if (quantity == 0 || totalForAllItems == 0) return 0;

    final basePrice = (orginalPrice - discount) * quantity;
    final extraCosts = handling + shipping + other;
    final cost = (basePrice / totalForAllItems) * extraCosts / quantity;

    return safeNumber(cost);
  }

  double get addDisc {
    if (quantity == 0 || totalForAllItems == 0) return 0;

    final basePrice = (orginalPrice - discount) * quantity;
    final extraDiscs = amount;
    final disc = (basePrice / totalForAllItems) * extraDiscs / quantity;

    return safeNumber(disc);
  }

  double get localPrice {
    return safeNumber((orginalPrice - discount + addCost - addDisc) * rate);
  }

  double get total {
    return safeNumber(localPrice * quantity);
  }

  double get net{
    return safeNumber(total + vat);
  }
}
