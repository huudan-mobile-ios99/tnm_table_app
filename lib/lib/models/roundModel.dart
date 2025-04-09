import 'dart:convert';

RoundModel roundModelFromJson(String str) =>
    RoundModel.fromJson(json.decode(str));

class RoundModel {
  final bool status;
  final String message;
  final int totalResult;
  final List<RankingRoundModel> data;

  RoundModel({
    required this.status,
    required this.message,
    required this.totalResult,
    required this.data,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) => RoundModel(
        // status: json["status"],
        // message: json["message"],
        // totalResult: json["totalResult"],
        // data: List<Ranking>.from(json["data"].map((x) => Ranking.fromJson(x))),
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        totalResult: json["totalResult"] ?? 0,
        data: (json["data"] as List<dynamic>?)
                ?.map((x) => RankingRoundModel.fromJson(x))
                .toList() ??
            [],
      );
}

class RankingRoundModel {
  final String id;
  final String datumId;
  final String name;
  final DateTime createdAt;
  final List<RankingRound> rankings;
  final int v;

  RankingRoundModel({
    required this.id,
    required this.datumId,
    required this.name,
    required this.createdAt,
    required this.rankings,
    required this.v,
  });

  factory RankingRoundModel.fromJson(Map<String, dynamic> json) => RankingRoundModel(
        id: json["_id"] ?? "",
        datumId: json["id"] ?? "",
        name: json["name"] ?? "",
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        rankings: (json["rankings"] as List<dynamic>?)
                ?.map((x) => RankingRound.fromJson(x))
                .toList() ??
            [],
        v: json["__v"] ?? 0,
      );
}
class RankingRound {
  final String? id;
  final int? datumId;
  final String? customerName;
  final String? customerNumber;
  final double? point;
  final DateTime? createdAt;
  final int? v;

  RankingRound({
    required this.id,
    required this.datumId,
    required this.customerName,
    required this.customerNumber,
    required this.point,
    required this.createdAt,
    required this.v,
  });

  factory RankingRound.fromJson(Map<String, dynamic> json) {
    return RankingRound(
      id: json["_id"],
      datumId: json["id"],
      customerName: json["customer_name"],
      customerNumber: json["customer_number"],
      point: json["point"]?.toDouble(),
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      v: json["__v"],
    );
  }
 
}