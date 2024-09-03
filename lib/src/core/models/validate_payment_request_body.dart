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

class AvsPaymentRequestBody {
  String reference;

  String address;

  String country;

  String state;

  String city;

  String zip;

  String merchantId;

  AvsPaymentRequestBody({
    required this.city,
    required this.country,
    required this.address,
    required this.state,
    required this.zip,
    required this.reference,
    required this.merchantId,
  });

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "authorization": {
        "avs": {
          "city": city,
          "address": address,
          "zipCode": zip,
          "state": state,
          "country": country
        }
      },
      "merchantId": merchantId
    };
  }
}
