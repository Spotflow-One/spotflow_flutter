import 'customer_info.dart';

class PaymentResponseBody {
  final String id;
  final String reference;
  final String spotflowReference;
  final num amount;
  final String currency;
  final String channel;
  final String status;
  final CustomerInfo customer;
  final String provider;
  final double?
      rate; // Made nullable to handle potential absence of "rate" object
  final Authorization?
      authorization; // Made nullable to handle potential absence of "authorization" object
  final DateTime? createdAt;
  final String? providerMessage;
  final BankDetails? bankDetails;
  final UssdResponse? ussd;

  PaymentResponseBody({
    required this.id,
    required this.reference,
    required this.spotflowReference,
    required this.amount,
    required this.currency,
    required this.channel,
    required this.status,
    required this.customer,
    required this.provider,
    this.rate,
    this.authorization,
    this.createdAt,
    this.providerMessage,
    this.bankDetails,
    this.ussd,
  });

  factory PaymentResponseBody.fromJson(Map<String, dynamic> json) =>
      PaymentResponseBody(
        id: json['id'] as String,
        reference: json['reference'] as String,
        spotflowReference: json['spotflowReference'] as String,
        amount: json['amount'] as num,
        currency: json['currency'] as String,
        channel: json['channel'] as String,
        status: json['status'] as String,
        customer:
            CustomerInfo.fromJson(json['customer'] as Map<String, dynamic>),
        provider: json['provider'] as String,
        rate: json['rate'],
        authorization: json['authorization'] != null
            ? Authorization.fromJson(
                json['authorization'] as Map<String, dynamic>)
            : null,
        bankDetails: json['bankDetails'] != null
            ? BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>)
            : null,
        ussd: json['ussd'] != null ? UssdResponse.fromJson(json['ussd']) : null,
        providerMessage: json['providerMessage'],
      );
}

class Rate {
  final String from;
  final String to;
  final num rate;

  Rate({
    required this.from,
    required this.to,
    required this.rate,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        from: json['from'] as String,
        to: json['to'] as String,
        rate: json['rate'] as num,
      );

  Rate copyWith({String? from, String? to, num? rate}) {
    return Rate(
      from: from ?? this.from,
      to: to ?? this.to,
      rate: rate ?? this.rate,
    );
  }
}

class Authorization {
  final String mode;
  final String? redirectUrl;

  Authorization({
    required this.mode,
    this.redirectUrl,
  });

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
        mode: json['mode'] as String,
        redirectUrl: json['redirectUrl'] as String?,
      );
}

class BankDetails {
  String accountNumber;
  String name;
  DateTime expiresAt;

  BankDetails({
    required this.name,
    required this.accountNumber,
  }) : expiresAt = _getDateTime();

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        accountNumber: json['accountNumber'] as String,
        name: json['bankName'] as String,
      );

  static DateTime _getDateTime() {
    return DateTime.now().add(const Duration(minutes: 30));
  }
}

class UssdResponse {
  String code;
  String paymentCode;

  UssdResponse({required this.code, required this.paymentCode});

  factory UssdResponse.fromJson(Map<String, dynamic> json) {
    return UssdResponse(
      code: json['code'],
      paymentCode: json['paymentCode'],
    );
  }
}
