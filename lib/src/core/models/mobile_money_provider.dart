import 'package:spotflow/src/core/models/country.dart';

class MobileMoneyProvider extends BaseModel {
  String code;

  MobileMoneyProvider({
    required this.code,
    required super.name,
  });

  factory MobileMoneyProvider.fromJson(Map<String, dynamic> json) {
    return MobileMoneyProvider(
      code: json['code'],
      name: json['name'],
    );
  }
}
