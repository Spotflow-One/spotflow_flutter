import 'package:spotflow/src/core/models/country.dart';
import 'package:uuid/uuid.dart';

import 'customer_info.dart';

class PaymentRequestBody {
  final String reference;
  num amount;

  String currency;
  String channel;
  String? encryptedCard;
  String? planId;
  CustomerInfo customer;
  Bank? bank;

  PaymentRequestBody({
    required this.customer,
    required this.currency,
    required this.amount,
    required this.channel,
    this.planId,
    this.encryptedCard,
    this.bank,
  }) : reference = _generateReference();

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'amount': amount,
      'currency': currency,
      'channel': channel,
      if (encryptedCard != null) 'encryptedCard': encryptedCard,
      if (planId != null) 'planId': planId,
      'customer': customer.toJson(),
      if (bank != null) "bank": bank!.toJson()
    };
  }

  static String _generateReference() {
    const uuid = Uuid();
    return "ref-${uuid.v4()}";
  }
}

class Bank extends BaseModel {
  String name;
  String code;

  Bank({required this.name, required this.code}) : super(name: name);

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {"code": code};
  }
}
