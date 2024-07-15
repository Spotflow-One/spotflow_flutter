import 'package:spotflow/src/core/models/spot_flow_card.dart';
import 'package:uuid/uuid.dart';

import 'customer_info.dart';

class PaymentRequestBody {
  final String reference;
  num amount;

  String currency;
  String channel;
  SpotFlowCard? card;
  String? planId;
  String provider;
  CustomerInfo customer;

  PaymentRequestBody({
    required this.customer,
    this.card,
    required this.currency,
    required this.amount,
    required this.channel,
    this.planId,
    required this.provider,
  }) : reference = _generateReference();

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'amount': amount,
      'currency': currency,
      'channel': channel,
      if (card != null) 'card': card?.toJson(),
      if (planId != null) 'planId': planId,
      'provider': provider,
      'customer': customer.toJson(),
    };
  }

  static String _generateReference() {
    const uuid = Uuid();
    return "ref-${uuid.v4()}";
  }
}
