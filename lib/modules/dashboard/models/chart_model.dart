class ChartModel {
  ChartModel({
    required this.date,
    required this.sales,
    required this.purchases,
  });

  final String? date;
  final int? sales;
  final int? purchases;

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      date: json["date"],
      sales: json["sales"],
      purchases: json["purchases"],
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "sales": sales,
        "purchases": purchases,
      };
}
