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
    if (paymentManager.amount == null && paymentManager.planId == null) {
      throw Exception('Please provide an amount or a plan id');
    }

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
                                _cancelPayment(context);
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
                                _cancelPayment(context);
                              },
                              paymentResponseBody: args.paymentResponseBody,
                            );
                      case SpotFlowRouteName.viewBankDetailsPage:
                        builder = (_) => ViewBankDetailsPage(
                              close: () {
                                _cancelPayment(context);
                              },
                            );
                      case SpotFlowRouteName.viewBanksUssdPage:
                        builder = (_) => ViewBanksUssdPage(
                              close: () {
                                _cancelPayment(context);
                              },
                            );
                      case SpotFlowRouteName.successPage:
                        final args = settings.arguments as SuccessPageArguments;
                        builder = (_) => SuccessPage(
                              successMessage: args.successMessage,
                              paymentOptionsEnum: args.paymentOptionsEnum,
                              close: () {
                                _cancelPayment(context);
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

  void _cancelPayment(BuildContext context) {
    context.read<AppStateProvider>().trackEvent('cancel_payment');

    Navigator.of(context).pop();
  }
}

class SpotFlowPaymentManager {
  String? customerId;

  Widget? appLogo;

  String? appName;

  String? customerName;

  String customerEmail;

  String currency;

  String? customerPhoneNumber;

  ///auth token
  String key;

  String encryptionKey;

  String? paymentDescription;

  String? planId;

  bool debugMode;

  num? amount;

  CustomerInfo get customer {
    return CustomerInfo(
      email: customerEmail,
      phoneNumber: customerPhoneNumber,
      name: customerName,
      id: customerId,
    );
  }

  SpotFlowPaymentManager({
    required this.key,
    required this.customerEmail,
    this.planId,
    required this.encryptionKey,
    this.customerName,
    this.customerPhoneNumber,
    this.customerId,
    this.paymentDescription,
    this.appLogo,
    this.appName,
    this.debugMode = true,
    this.amount,
    required this.currency,
  });
}
