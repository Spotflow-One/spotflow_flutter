class ApiRoute {
  static const baseUrl = 'http://dev-api.spotflow.one';
  static const validatePayment = '$baseUrl/api/v1/payments/validate';
  static const verifyPayment = '$baseUrl/api/v1/payments/verify';
  static const authorizePayment = '$baseUrl/api/v1/payments/authorize';
  static const createPayment = '$baseUrl/api/v1/payments';
  static const fetchRate = '$baseUrl/api/v1/payments/rates';
}
