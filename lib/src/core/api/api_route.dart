class ApiRoute {
  final bool isDebugMode;

  ApiRoute({required this.isDebugMode});

  String get baseUrl {
    if (isDebugMode) {
      return 'https://dev-api.spotflow.co';
    }
    return 'https://api.spotflow.co';
  }

  String get validatePayment => '$baseUrl/api/v1/payments/validate';
  String get verifyPayment => '$baseUrl/api/v1/payments/verify';
  String get authorizePayment => '$baseUrl/api/v1/payments/authorize';
  String get createPayment => '$baseUrl/api/v1/payments';
  String get fetchRate => '$baseUrl/api/v1/payments/rates';
  String get getUssdBanks => '$baseUrl/api/v1/banks';
  String get retryPayment => '$baseUrl/api/v1/payments/retry';

  String get mobileMoneyProviders => '$baseUrl/api/v1/mobile-money/providers';

  String get getMerchantConfig => "$baseUrl/api/v1/checkout-configurations";
}
