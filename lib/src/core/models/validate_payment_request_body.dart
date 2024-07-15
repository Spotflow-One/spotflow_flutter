class ValidatePaymentRequestBody {
  String otp;
  String reference;
  String merchantId;

  ValidatePaymentRequestBody({
    required this.merchantId,
    required this.reference,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "authorization": {"otp": otp},
      "merchantId": merchantId
    };
  }
}
