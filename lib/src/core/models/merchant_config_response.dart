import 'package:spotflow/src/core/models/payment_options_enum.dart';

import 'payment_response_body.dart';

class MerchantConfig {
  String merchantName;

  String merchantLogo;

  List<PaymentOptionsEnum?> paymentMethods;

  SpotFlowPlan plan;

  Rate rate;

  MerchantConfig({
    required this.merchantLogo,
    required this.merchantName,
    required this.paymentMethods,
    required this.plan,
    required this.rate,
  });

  factory MerchantConfig.fromJson(Map<String, dynamic> json) {
    return MerchantConfig(
      merchantLogo: json['merchantLogo'],
      merchantName: json['merchantName'],
      paymentMethods: (json['paymentMethods'] as List)
          .map<PaymentOptionsEnum?>((e) => PaymentOptionsEnum.fromString(e))
          .toList(),
      plan: SpotFlowPlan.fromJson(json['plan']),
      rate: Rate.fromJson(
        json['rate'],
      ),
    );
  }
}

class SpotFlowPlan {
  String id;

  String title;

  String frequency;

  num amount;

  String currency;

  String status;

  SpotFlowPlan({
    required this.status,
    required this.id,
    required this.amount,
    required this.title,
    required this.currency,
    required this.frequency,
  });

  factory SpotFlowPlan.fromJson(Map<String, dynamic> json) {
    return SpotFlowPlan(
      status: json['status'],
      id: json['id'],
      amount: json['amount'],
      title: json['title'],
      currency: json['currency'],
      frequency: json['frequency'],
    );
  }
}
