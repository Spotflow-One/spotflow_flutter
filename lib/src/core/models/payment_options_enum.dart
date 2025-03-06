import 'package:flutter/cupertino.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

enum PaymentOptionsEnum {
  card,
  transfer,
  ussd,
  mobileMoney;

  static PaymentOptionsEnum? fromString(String string) {
    if (string.toLowerCase() == "card") {
      return PaymentOptionsEnum.card;
    } else if (string.toLowerCase() == "bank_transfer") {
      return PaymentOptionsEnum.transfer;
    } else if (string.toLowerCase() == "ussd") {
      return PaymentOptionsEnum.ussd;
    } else if (string.toLowerCase() == 'mobile_money') {
      return PaymentOptionsEnum.mobileMoney;
    }
    return null;
  }
}

extension Helpers on PaymentOptionsEnum {
  Widget get icon {
    switch (this) {
      case PaymentOptionsEnum.card:
        return Assets.svg.card.svg();
      case PaymentOptionsEnum.transfer:
        return Assets.svg.bank.svg();
      case PaymentOptionsEnum.ussd:
        return Assets.svg.hashtag.svg();
      case PaymentOptionsEnum.mobileMoney:
        return Assets.svg.mobile.svg(
            colorFilter: const ColorFilter.mode(
                SpotFlowColors.tone100, BlendMode.srcIn));
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
      case PaymentOptionsEnum.mobileMoney:
        return 'Pay with Mobile Money';
    }
  }
}
