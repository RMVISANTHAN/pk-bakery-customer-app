class Address {
  final String id;
  final String label;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pincode;
  final double? lat;
  final double? lng;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pincode,
    this.lat,
    this.lng,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['_id'] ?? '',
        label: json['label'] ?? 'Home',
        line1: json['line1'] ?? '',
        line2: json['line2'],
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        pincode: json['pincode'] ?? '',
        lat: json['lat']?.toDouble(),
        lng: json['lng']?.toDouble(),
        isDefault: json['isDefault'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'pincode': pincode,
        'lat': lat,
        'lng': lng,
        'isDefault': isDefault,
      };
}

class AppUser {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Address> addresses;

  AppUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.addresses = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'],
        phone: json['phone'],
        addresses: (json['addresses'] as List? ?? []).map((a) => Address.fromJson(a)).toList(),
      );
}
