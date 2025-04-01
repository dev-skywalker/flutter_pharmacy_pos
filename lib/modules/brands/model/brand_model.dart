class Brands {
  Brands({
    this.description,
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? description;
  final int? createdAt;
  final int? updatedAt;

  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
