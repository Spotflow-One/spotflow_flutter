import 'dart:convert';

class SpotFlowCard {
  String pan;
  String cvv;
  String expiryYear;
  String expiryMonth;

  SpotFlowCard({
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
    required this.pan,
  });

  Map<String, dynamic> toJson() => {
        'pan': pan,
        'cvv': cvv,
        'expiryYear': expiryYear,
        'expiryMonth': expiryMonth,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }

// String toJson() {
  //   return '''
  // {
  // "pan" : "$pan",
  // "cvv": "$cvv",
  // "expiryYear":"$expiryYear",
  // "expiryMonth":"$expiryMonth"
  // }
  // ''';
  // }
}
