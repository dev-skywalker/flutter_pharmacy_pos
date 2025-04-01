class Category {
  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
