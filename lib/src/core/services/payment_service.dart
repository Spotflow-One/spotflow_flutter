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

  Future<Response> retryPayment(
      PaymentRequestBody paymentRequestBody,
      ) {
    return apiClient.post(
      apiRoute.retryPayment,
      data: paymentRequestBody.retryJson(),
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
  }) {
    return apiClient.get(
      'https://dev-api.spotflow.co/api/v1/payments/verify?reference=$reference',
    );
  }

  Future<Response> getBanks() {
    return apiClient
        .get(apiRoute.getUssdBanks, queryParameters: {"ussd": true});
  }

  Future<Response> getMobileMoneyProviders() {
    return apiClient.get(apiRoute.mobileMoneyProviders);
  }

  Future<Response> getMerchantConfig(
      {required String? planId, required String? currency}) async {
    Map<String, dynamic> queryParams = {};
    if (planId != null) {
      queryParams['planId'] = planId;
    }
    if (currency != null) {
      queryParams['currency'] = currency;
    }
    final response = await apiClient.get(apiRoute.getMerchantConfig,
        queryParameters: queryParams);

    return response;
  }

  Future<Response> getRate({required String from, required String to}) async {
    final response = await apiClient
        .get(apiRoute.fetchRate, queryParameters: {"from": from, "to": to});
    return response;
  }
}
