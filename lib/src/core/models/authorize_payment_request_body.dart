class AuthorizePaymentRequestBody {
  String pin;
  String reference;

  AuthorizePaymentRequestBody({
    required this.reference,
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "authorization": {"pin": pin},
    };
  }
}
