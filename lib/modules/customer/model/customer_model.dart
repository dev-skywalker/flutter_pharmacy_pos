class CustomerModel {
  CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.city,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? city;
  final String? address;
  final int? createdAt;
  final int? updatedAt;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      city: json["city"],
      address: json["address"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "address": address,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
