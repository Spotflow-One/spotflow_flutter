import 'package:spotflow/src/core/models/country.dart';
import 'package:uuid/uuid.dart';

import 'customer_info.dart';

class PaymentRequestBody {
  String reference;
  num amount;

  String currency;
  String channel;
  String? encryptedCard;
  String? planId;
  CustomerInfo customer;
  Bank? bank;
  MobileMoney? mobileMoney;

  PaymentRequestBody({
    required this.customer,
    required this.currency,
    required this.amount,
    required this.channel,
    this.planId,
    this.encryptedCard,
    this.bank,
    this.mobileMoney,
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
      'metadata': {},
      if (bank != null) "bank": bank!.toJson(),
      if (mobileMoney != null) "mobileMoney": mobileMoney!.toJson(),
    };
  }

  Map<String, dynamic> retryJson() {
    return {
      'reference': reference,
      'channel': channel,
      'callbackUrl': "",
      if (encryptedCard != null) 'encryptedCard': encryptedCard,
      if (bank != null) "bank": bank!.toJson(),
      if (mobileMoney != null) "mobileMoney": mobileMoney!.toJson(),
    };
  }

  static String _generateReference() {
    const uuid = Uuid();
    return "ref-${uuid.v4().toUpperCase()}";
  }
}

class Bank extends BaseModel {
  String code;

  Bank({required super.name, required this.code});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {"code": code};
  }
}

class MobileMoney {
  String phoneNumber;
  String code;

  MobileMoney({
    required this.code,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "phoneNumber": phoneNumber,
    };
  }
}
