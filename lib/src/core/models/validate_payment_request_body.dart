class ValidatePaymentRequestBody {
  String otp;
  String reference;

  ValidatePaymentRequestBody({
    required this.reference,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "authorization": {"otp": otp},
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

  AvsPaymentRequestBody({
    required this.city,
    required this.country,
    required this.address,
    required this.state,
    required this.zip,
    required this.reference,
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
    };
  }
}
