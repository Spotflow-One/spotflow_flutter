import 'package:flutter/cupertino.dart';
import 'package:spotflow/gen/assets.gen.dart';

enum PaymentOptionsEnum {
  card,
  transfer,
  ussd,
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
