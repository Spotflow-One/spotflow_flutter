import 'package:flutter/material.dart';
import 'package:spotflow/src/core/models/customer_info.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/views/home_page.dart';

class Spotflow {
  start({
    required BuildContext context,
    required SpotFlowPaymentManager paymentManager,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
          settings: const RouteSettings(
            name: SpotFlowRouteName.homePage,
          ),
          builder: (context) => HomePage(paymentManager: paymentManager)),
    );
  }
}

class SpotFlowPaymentManager {
  String? customerId;

  Widget? appLogo;

  String? appName;

  String? customerName;

  String customerEmail;

  String? customerPhoneNumber;

  String merchantId;

  String paymentId;

  String fromCurrency;

  String toCurrency;

  num amount;

  ///auth token
  String key;

  String provider;

  String? paymentDescription;

  CustomerInfo get customer {
    return CustomerInfo(
      email: customerEmail,
      phoneNumber: customerPhoneNumber,
      name: customerName,
      id: customerId,
    );
  }

  SpotFlowPaymentManager({
    required this.merchantId,
    required this.paymentId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.key,
    required this.provider,
    required this.customerEmail,
    this.customerName,
    this.customerPhoneNumber,
    this.customerId,
    this.paymentDescription,
    this.appLogo,
    this.appName,
  });
}
