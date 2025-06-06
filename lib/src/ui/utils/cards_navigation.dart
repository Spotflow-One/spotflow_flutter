import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/views/authorization_web_view.dart';
import 'package:spotflow/src/ui/views/card/enter_billing_address_page.dart';
import 'package:spotflow/src/ui/views/card/enter_otp_page.dart';
import 'package:spotflow/src/ui/views/card/enter_pin_page.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';

import 'spot_flow_route_name.dart';

mixin CardsNavigation {
  void handleCardSuccessResponse({
    required PaymentResponseBody paymentResponseBody,
    required SpotFlowPaymentManager paymentManager,
    required GestureTapCallback onCancelPayment,
    required BuildContext context,
  }) {
    if (paymentResponseBody.status == 'successful') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        SpotFlowRouteName.successPage,
        (route) {
          return route.isFirst;
        },
        arguments: SuccessPageArguments(
          paymentOptionsEnum: PaymentOptionsEnum.card,
          paymentResponseBody: paymentResponseBody,
          successMessage: "Card payment successful",
          close: onCancelPayment,
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'pin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnterPinPage(
            reference: paymentResponseBody.reference,
            onClose: onCancelPayment,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'otp') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnterOtpPage(
            message: paymentResponseBody.providerMessage ?? "",
            reference: paymentResponseBody.reference,
            close: onCancelPayment,

          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == '3DS') {
      String? redirectUrl = paymentResponseBody.authorization?.redirectUrl;

      if (redirectUrl == null) {
        return;
      }

      context.read<AppStateProvider>().trackEvent('auth_redirect');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SpotFlowInAppBrowser(
            url: redirectUrl,
            reference: paymentResponseBody.reference,
            onClose: onCancelPayment,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'avs') {
      Navigator.of(context).pushReplacementNamed(
        SpotFlowRouteName.enterBillingAddressPage,
        arguments: EnterBillingAddressPageArgs(
            paymentResponseBody: paymentResponseBody),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            message: paymentResponseBody.providerMessage ?? "",
            paymentOptionsEnum: PaymentOptionsEnum.card,
          ),
        ),
      );
    }
  }
}
