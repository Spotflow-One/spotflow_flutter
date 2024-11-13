import 'package:dio/dio.dart';
import 'package:spotflow/src/core/api/api_client.dart';
import 'package:spotflow/src/core/api/api_route.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';

class PaymentService {
  final String authToken;
  final bool isDebugMode;

  PaymentService(this.authToken, this.isDebugMode);

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

  Future<Response> getMerchantConfig({required String? planId}) async {
    final response = await apiClient.get(
      apiRoute.getMerchantConfig,
      queryParameters: planId == null
          ? {}
          : {
              "planId": planId,
            },
    );

    return response;
  }
}
