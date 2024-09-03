import 'package:flutter/cupertino.dart';
import 'package:spotflow/gen/assets.gen.dart';

enum PaymentOptionsEnum {
  card,
  transfer,
  ussd;

  static PaymentOptionsEnum? fromString(String string) {
    if (string.toLowerCase() == "card") {
      return PaymentOptionsEnum.card;
    } else if (string.toLowerCase() == "bank_transfer") {
      return PaymentOptionsEnum.transfer;
    } else if (string.toLowerCase() == "ussd") {
      return PaymentOptionsEnum.ussd;
    }
    return null;
  }
}

extension Helpers on PaymentOptionsEnum {
  Widget get icon {
    switch (this) {
      case PaymentOptionsEnum.card:
        return Assets.svg.payWithCardIcon.svg();
      case PaymentOptionsEnum.transfer:
        return Assets.svg.payWithTransferIcon.svg();
      case PaymentOptionsEnum.ussd:
        return Assets.svg.payWithTransferIcon.svg();
    }
  }

  String get title {
    switch (this) {
      case PaymentOptionsEnum.card:
        return "Pay with Card";
      case PaymentOptionsEnum.transfer:
        return "Pay with Transfer";
      case PaymentOptionsEnum.ussd:
        return "Pay with USSD";
    }
  }
}
