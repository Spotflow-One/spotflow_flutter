class ApiRoute {
  static const baseUrl = 'https://dev-api.spotflow.co';
  static const validatePayment = '$baseUrl/api/v1/payments/validate';
  static const verifyPayment = '$baseUrl/api/v1/payments/verify';
  static const authorizePayment = '$baseUrl/api/v1/payments/authorize';
  static const createPayment = '$baseUrl/api/v1/payments';
  static const fetchRate = '$baseUrl/api/v1/payments/rates';
  static const getUssdBanks = '$baseUrl/api/v1/banks';

  static String getMerchantConfig = "$baseUrl/api/v1/checkout-configurations";
}
