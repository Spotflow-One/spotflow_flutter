class CustomerInfo {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;

  CustomerInfo({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        // Include id only if not null
        if (name != null) 'name': name,
        // Include name only if not null
        'email': email,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        // Include phoneNumber only if not null
      };

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        id: json['id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'],
      );
}
