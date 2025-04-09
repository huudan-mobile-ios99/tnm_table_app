class ListRoundRealTimeModel {
  final List<RoundRealtimeModel> list;

  ListRoundRealTimeModel({required this.list});
  factory ListRoundRealTimeModel.fromJson(List<dynamic> json) {
    List<RoundRealtimeModel> list =json.map((data) => RoundRealtimeModel.fromJson(data)).toList();
    return ListRoundRealTimeModel(list: list);
  }
}

class RoundRealtimeModel {
  final String id;
  final DateTime createdAt;
  final List<ItemRoundRealtime> items;

  RoundRealtimeModel({
    required this.id,
    required this.createdAt,
    required this.items,
  });

  factory RoundRealtimeModel.fromJson(Map<String, dynamic> json) =>
      RoundRealtimeModel(
        id: json["_id"]!,
        createdAt: DateTime.parse(json["createdAt"]),
        items: List<ItemRoundRealtime>.from(
          json['items'].map((itemJson) => ItemRoundRealtime.fromJson(itemJson)),
        ),
      );
}

class ItemRoundRealtime {
  final String id;
  final String roundName;
  final String customerName;
  final String customerNumber;
  final int point;
  final DateTime createdAt;
  final int v;

  ItemRoundRealtime({
    required this.id,
    required this.roundName,
    required this.customerName,
    required this.customerNumber,
    required this.point,
    required this.createdAt,
    required this.v,
  });

  factory ItemRoundRealtime.fromJson(Map<String, dynamic> json) =>
      ItemRoundRealtime(
        id: json["_id"],
        roundName: json["roundName"]!,
        customerName: json["customer_name"],
        customerNumber: json["customer_number"],
        point: json["point"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );
}

List<RoundRealtimeModel> parseRoundRealtimeModelList(List<dynamic> json) {
  return json.map((roundJson) {
    return RoundRealtimeModel.fromJson(roundJson);
  }).toList();
}
