import 'package:datahubai/Models/car trading/car_trading_purchase_agreement_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy agreements remain sales agreements', () {
    final agreement = CarTradingPurchaseAgreementModel.fromJson({
      '_id': 'agreement-1',
      'agreement_number': 'SALE-001',
      'agreement_date': '2026-09-15T00:00:00.000',
      'seller_id': 'legacy-seller-id',
      'buyer_id': 'legacy-buyer-id',
      'amount': '12500.50',
      'downpayment': 2500,
    });

    expect(agreement.agreementType, 'sell');
    expect(agreement.isPurchase, isFalse);
    expect(agreement.sellerID, 'legacy-seller-id');
    expect(agreement.buyerID, 'legacy-buyer-id');
    expect(agreement.amount, 12500.50);
    expect(agreement.aownpayment, 2500);
  });

  test('buy agreement uses the backend field names and round-trips', () {
    final original = CarTradingPurchaseAgreementModel(
      id: 'agreement-2',
      tradeId: 'trade-1',
      agreementNumber: 'BUY-001',
      agreementDate: DateTime.utc(2026, 9, 15),
      agreementType: 'buy',
      paymentMethod: 'bank_transfer',
      sellerName: 'Vehicle Seller',
      sellerID: 'seller-id',
      sellerPhone: '0500000000',
      sellerEmail: 'seller@example.com',
      buyerName: 'Example Vehicle Trading LLC',
      buyerID: 'licence-1',
      buyerPhone: '040000000',
      buyerEmail: 'buyer@example.com',
      amount: 87500.25,
      aownpayment: 20000,
      note: 'Two keys supplied.',
    );

    final json = original.toJson();
    expect(json['agreement_type'], 'buy');
    expect(json['payment_method'], 'bank_transfer');
    expect(json, isNot(contains('profit_margin_scheme')));
    expect(json['seller_ID'], 'seller-id');
    expect(json['buyer_ID'], 'licence-1');
    expect(json['agreement_amount'], 87500.25);
    expect(json['agreement_down_payment'], 20000);
    expect(json, isNot(contains('seller_id')));
    expect(json, isNot(contains('amount')));

    final restored = CarTradingPurchaseAgreementModel.fromJson(json);
    expect(restored.isPurchase, isTrue);
    expect(restored.paymentMethod, 'bank_transfer');
    expect(restored.amount, 87500.25);
    expect(restored.aownpayment, 20000);
  });
}
