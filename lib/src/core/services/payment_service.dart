import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/api/api_client.dart';
import 'package:spotflow/src/core/api/api_route.dart';
import 'package:spotflow/src/core/models/authorize_payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/ui/views/card/enter_otp_page.dart';
import 'package:spotflow/src/ui/views/card/enter_pin_page.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';

class PaymentService {
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

  getRate() async {}
}
