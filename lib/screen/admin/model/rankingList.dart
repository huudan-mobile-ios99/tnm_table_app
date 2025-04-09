

class RankingModel {
  final bool? status;
  final String? message;
  final int? totalResult;
  final List<Ranking>? data;

  RankingModel({
    required this.status,
    required this.message,
    required this.totalResult,
    required this.data,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      status: json["status"],
      message: json["message"],
      totalResult: json["totalResult"],
      data: (json["data"] as List)
          .map((x) => Ranking.fromJson(x))
          .toList(),
    );
  }
  
}

class Ranking {
  final String? id;
  final String? customerName;
  final String? customerNumber;
  final double? point;
  final String? createdAt;
  final int? v;

  Ranking({
    this.id,
    required this.customerName,
    required this.customerNumber,
    required this.point,
    required this.createdAt,
    required this.v,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      id: json["_id"],
      customerName: json["customer_name"],
      customerNumber: json["customer_number"],
      point: json["point"]?.toDouble(),
      createdAt: json['createdAt'],
      // createdAt: json["createdAt"] != null
      //     ? DateTime.parse(json["createdAt"])
      //     : DateTime(2000,01,01),
      v: json["__v"],
    );
  }
 
}
