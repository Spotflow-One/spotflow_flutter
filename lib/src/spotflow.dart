import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/core/models/customer_info.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/views/card/enter_billing_address_page.dart';
import 'package:spotflow/src/ui/views/card/enter_card_details_page.dart';
import 'package:spotflow/src/ui/views/home_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/views/ussd/view_banks_ussd_page.dart';

class Spotflow {
  start({
    required BuildContext context,
    required SpotFlowPaymentManager paymentManager,
    void Function(PaymentResponseBody paymentResponseBody)? onComplete,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              builder: (context, child) {
                return Navigator(
                  initialRoute: SpotFlowRouteName.homePage,
                  onGenerateRoute: (RouteSettings settings) {
                    WidgetBuilder builder;
                    switch (settings.name) {
                      case SpotFlowRouteName.homePage:
                        builder = (_) => HomePage(
                              paymentManager: paymentManager,
                              closeSpotFlow: () {
                                Navigator.of(context).pop();
                              },
                            );
                      case SpotFlowRouteName.enterCardDetailsPage:
                        builder = (_) => EnterCardDetailsPage(
                              close: () {
                                Navigator.of(context).pop();
                              },
                            );
                      case SpotFlowRouteName.enterBillingAddressPage:
                        final args =
                            settings.arguments as EnterBillingAddressPageArgs;
                        builder = (_) => EnterBillingAddressPage(
                              close: () {
                                Navigator.of(context).pop();
                              },
                              paymentResponseBody: args.paymentResponseBody,
                            );
                      case SpotFlowRouteName.viewBankDetailsPage:
                        builder = (_) => ViewBankDetailsPage(
                              close: () {
                                Navigator.of(context).pop();
                              },
                            );
                      case SpotFlowRouteName.viewBanksUssdPage:
                        builder = (_) => ViewBanksUssdPage(
                              close: () {
                                Navigator.of(context).pop();
                              },
                            );
                      case SpotFlowRouteName.successPage:
                        final args = settings.arguments as SuccessPageArguments;
                        builder = (_) => SuccessPage(
                              successMessage: args.successMessage,
                              paymentOptionsEnum: args.paymentOptionsEnum,
                              close: () {
                                Navigator.of(context).pop();
                              },
                              onComplete: () {
                                onComplete?.call(args.paymentResponseBody);
                              },
                            );
                      default:
                        throw Exception('Invalid route: ${settings.name}');
                    }

                    return MaterialPageRoute<void>(
                        builder: builder, settings: settings);
                  },
                );
              },
              create: (BuildContext context) => AppStateProvider(
                paymentManager: paymentManager,
              ),
            )));
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

  num amount;

  ///auth token
  String key;

  String encryptionKey;

  String? paymentDescription;

  String planId;

  Function(PaymentResponseBody paymentResponse)? onComplete;

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
    required this.amount,
    required this.key,
    required this.customerEmail,
    required this.planId,
    required this.encryptionKey,
    this.customerName,
    this.customerPhoneNumber,
    this.customerId,
    this.paymentDescription,
    this.appLogo,
    this.appName,
    this.onComplete,
  });
}
