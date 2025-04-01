class Units {
  Units({
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

  factory Units.fromJson(Map<String, dynamic> json) {
    return Units(
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
