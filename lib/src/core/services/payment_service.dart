import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/api/api_client.dart';
import 'package:spotflow/src/core/api/api_route.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/views/authorization_web_view.dart';
import 'package:spotflow/src/ui/views/card/enter_billing_address_page.dart';
import 'package:spotflow/src/ui/views/card/enter_otp_page.dart';
import 'package:spotflow/src/ui/views/card/enter_pin_page.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';

class PaymentService {
  final String authToken;
  final bool isDebugMode;

  PaymentService(this.authToken, {this.isDebugMode = true});

  ApiClient get apiClient => ApiClient(authToken);

  ApiRoute get apiRoute => ApiRoute(isDebugMode: isDebugMode);

  Future<Response> createPayment(
    PaymentRequestBody paymentRequestBody,
  ) {
    return apiClient.post(
      apiRoute.createPayment,
      data: paymentRequestBody.toJson(),
    );
  }

  Future<Response> authorizePayment(
    Map<String, dynamic> body,
  ) {
    return apiClient.post(
      apiRoute.authorizePayment,
      data: body,
    );
  }

  Future<Response> verifyPayment({
    required String reference,
    required String merchantId,
  }) {
    return apiClient.get(apiRoute.verifyPayment, queryParameters: {
      "merchantId": merchantId,
      "reference": reference,
    });
  }

  Future<Response> getBanks() {
    return apiClient
        .get(apiRoute.getUssdBanks, queryParameters: {"ussd": true});
  }

  void handleCardSuccessResponse({
    required Response<dynamic> response,
    required SpotFlowPaymentManager paymentManager,
    required BuildContext context,
  }) {
    if (context.mounted == false) return;
    final paymentResponseBody = PaymentResponseBody.fromJson(response.data);
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
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'pin') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnterPinPage(
            reference: paymentResponseBody.reference,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'otp') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnterOtpPage(
            message: paymentResponseBody.providerMessage ?? "",
            reference: paymentResponseBody.reference,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == '3DS') {
      String? redirectUrl = paymentResponseBody.authorization?.redirectUrl;

      if (redirectUrl == null) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SpotFlowInAppBrowser(
            url: redirectUrl,
            reference: paymentResponseBody.reference,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'avs') {
      Navigator.of(context).pushNamed(
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

  Future<Response> getMerchantConfig({required String planId}) async {
    final response = await apiClient
        .get(apiRoute.getMerchantConfig, queryParameters: {"planId": planId});

    return response;
  }
}
