class AuthorizePaymentRequestBody {
  String pin;
  String reference;
  String merchantId;

  AuthorizePaymentRequestBody({
    required this.merchantId,
    required this.reference,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "authorization": {"pin": pin},
      "merchantId": merchantId
    };
  }
}
