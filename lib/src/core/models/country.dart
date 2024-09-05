abstract class BaseModel {
  String name;

  BaseModel({required this.name});
}

class Country extends BaseModel {
  List<CountryState> states;

  Country({required super.name, required this.states});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String,
      states: (json['states'] as List<dynamic>)
          .map((state) => CountryState.fromJson(state))
          .toList(),
    );
  }
}

class CountryState extends BaseModel {
  List<City> cities;

  CountryState({required super.name, required this.cities});

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      name: json['name'] as String,
      cities: (json['cities'] as List<dynamic>)
          .map((city) => City.fromJson(city))
          .toList(),
    );
  }
}

class City extends BaseModel {
  City({required super.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
    );
  }
}
