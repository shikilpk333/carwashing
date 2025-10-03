class AddressModel {
  final String id;
  final String address;
  final String phone;
  final String city;
  final String state;
  final String postalCode;

  AddressModel({
    required this.id,
    required this.address,
    required this.phone,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'phone': phone,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
    );
  }
}
