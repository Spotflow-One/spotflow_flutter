import 'package:flutter/material.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/merchant_config_response.dart';

class AppStateProvider extends ChangeNotifier {
  MerchantConfig? merchantConfig;
  final SpotFlowPaymentManager? paymentManager;

  AppStateProvider({
    this.merchantConfig,
    required this.paymentManager,
  });

  updateRate(num rate) {
    if (merchantConfig == null) return;
    merchantConfig!.rate = merchantConfig!.rate.copyWith(rate: rate);
    notifyListeners();
  }

  setMerchantConfig(MerchantConfig merchantConfig) {
    this.merchantConfig = merchantConfig;
    notifyListeners();
  }
}
