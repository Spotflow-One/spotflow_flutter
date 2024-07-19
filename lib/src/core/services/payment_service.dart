import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/api/api_client.dart';
import 'package:spotflow/src/core/api/api_route.dart';
import 'package:spotflow/src/core/models/authorize_payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/ui/views/authorization_web_view.dart';
import 'package:spotflow/src/ui/views/card/enter_otp_page.dart';
import 'package:spotflow/src/ui/views/card/enter_pin_page.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';

class PaymentService implements TransactionCallBack {
  final String authToken;

  PaymentService(this.authToken);

  ApiClient get apiClient => ApiClient(authToken);

  Future<Response> createPayment(
    PaymentRequestBody paymentRequestBody,
  ) {
    return apiClient.post(
      ApiRoute.createPayment,
      data: paymentRequestBody.toJson(),
    );
  }

  Future<Response> authorizePayment(
    AuthorizePaymentRequestBody body,
  ) {
    return apiClient.post(
      ApiRoute.authorizePayment,
      data: body.toJson(),
    );
  }

  Future<Response> validatePayment(
    ValidatePaymentRequestBody body,
  ) {
    return apiClient.post(
      ApiRoute.validatePayment,
      data: body.toJson(),
    );
  }

  Future<Response> verifyPayment({
    required String reference,
    required String merchantId,
  }) {
    return apiClient.get(ApiRoute.verifyPayment, queryParameters: {
      "merchantId": merchantId,
      "reference": reference,
    });
  }

  void handleCardSuccessResponse(
      {required Response<dynamic> response,
      required SpotFlowPaymentManager paymentManager,
      required BuildContext context}) {
    if (context.mounted == false) return;
    final paymentResponseBody = PaymentResponseBody.fromJson(response.data);
    if (paymentResponseBody.status == 'successful') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            paymentOptionsEnum: PaymentOptionsEnum.card,
            paymentManager: paymentManager,
            successMessage: "Card payment successful",
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'pin') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnterPinPage(
            reference: paymentResponseBody.reference,
            paymentManager: paymentManager,
            rate: paymentResponseBody.rate,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == 'otp') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnterOtpPage(
            message: paymentResponseBody.providerMessage ?? "",
            paymentManager: paymentManager,
            reference: paymentResponseBody.reference,
            rate: paymentResponseBody.rate,
          ),
        ),
      );
    } else if (paymentResponseBody.authorization?.mode == '3DS') {
      if (paymentManager.provider == 'flutterwave') {
        final settings = InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
            hideUrlBar: true,
            hideTitleBar: true,
          ),
          webViewSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
          ),
        );
        final browser = FlutterwaveInAppBrowser(callBack: this);

        browser.openUrlRequest(
          urlRequest: URLRequest(
              url: WebUri(
            paymentResponseBody.authorization!.redirectUrl!,
          )),
          settings: settings,
        );
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            paymentManager: paymentManager,
            message: paymentResponseBody.providerMessage ?? "",
            paymentOptionsEnum: PaymentOptionsEnum.card,
            rate: paymentResponseBody.rate,
          ),
        ),
      );
    }
  }

  Future<Response> getRate({required String from, required String to}) async {
    final response = await apiClient
        .get(ApiRoute.fetchRate, queryParameters: {"from": from, "to": to});
    return response;
  }

  @override
  onTransactionComplete(ChargeResponse? chargeResponse) {
    print('charge response');
    print(chargeResponse?.toJson());
  }
}
