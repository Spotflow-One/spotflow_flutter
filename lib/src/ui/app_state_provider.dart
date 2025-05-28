import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/merchant_config_response.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';

class AppStateProvider extends ChangeNotifier {
  MerchantConfig? merchantConfig;
  final SpotFlowPaymentManager paymentManager;
  PaymentResponseBody? paymentResponseBody;

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
    return merchantConfig?.plan?.amount ?? paymentManager.amount;
  }

  String? get currencyName {
    String? from = merchantConfig?.rate.from;

    if (from == "NGN") {
      return "Naira";
    }
    return null;
  }

  String getFormattedAmount() {
    final amount = merchantConfig?.plan?.amount ?? paymentManager.amount;
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

  Future<PaymentResponseBody?> startPayment(
      PaymentRequestBody paymentRequestBody) async {
    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);

    if (paymentResponseBody == null ||
        paymentResponseBody?.status == 'pending') {
      final response = await paymentService.createPayment(paymentRequestBody);
      paymentResponseBody = PaymentResponseBody.fromJson(response.data);
    } else {
      paymentRequestBody.reference = paymentResponseBody!.reference;
      final response = await paymentService.retryPayment(paymentRequestBody);
      paymentResponseBody = PaymentResponseBody.fromJson(response.data);
    }

    return paymentResponseBody;
  }

  trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) {
    // mixpanel?.track(eventName, properties: {'sdk': 'flutter', ...?properties});
  }
}
