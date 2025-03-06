import 'package:flutter/material.dart';

// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/merchant_config_response.dart';

class AppStateProvider extends ChangeNotifier {
  MerchantConfig? merchantConfig;
  final SpotFlowPaymentManager? paymentManager;

  // Mixpanel? mixpanel;

  AppStateProvider({
    this.merchantConfig,
    required this.paymentManager,
  }) {
    _initMixpanel();
  }

  updateRate(num rate) {
    if (merchantConfig == null) return;
    merchantConfig!.rate = merchantConfig!.rate.copyWith(rate: rate);
    notifyListeners();
  }

  num? get amount {
    return merchantConfig?.plan?.amount ?? paymentManager?.amount;
  }

  String getFormattedAmount() {
    final amount = merchantConfig?.plan?.amount ?? paymentManager?.amount;
    String formattedAmount = "";

    formattedAmount =
        'Pay ${merchantConfig!.rate.from} ${amount?.toStringAsFixed(2) ?? ""}';

    return formattedAmount;
  }

  setMerchantConfig(MerchantConfig merchantConfig) {
    this.merchantConfig = merchantConfig;
    notifyListeners();
  }

  Future<void> _initMixpanel() async {
    // mixpanel = await Mixpanel.init(
    //   "11162d9a0801daeaf786f1200cd3112b",
    //   trackAutomaticEvents: false,
    // );
    // mixpanel?.setLoggingEnabled(paymentManager?.debugMode ?? false);
  }

  trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) {
    // mixpanel?.track(eventName, properties: {'sdk': 'flutter', ...?properties});
  }
}
