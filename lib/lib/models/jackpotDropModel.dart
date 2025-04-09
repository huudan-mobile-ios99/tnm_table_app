
class JackpotHistoryModel {
    bool status;
    String message;
    List<JackpotHistoryModelData> data;

    JackpotHistoryModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory JackpotHistoryModel.fromJson(Map<String, dynamic> json) => JackpotHistoryModel(
        status: json["status"],
        message: json["message"],
        data: List<JackpotHistoryModelData>.from(json["data"].map((x) => JackpotHistoryModelData.fromJson(x))),
    );

  
}

class JackpotHistoryModelData {
    String id;
    String name;
    double value;
    int? machineId;
    int count;
    bool? status;
    DateTime createdAt;
    int v;

    JackpotHistoryModelData({
        required this.id,
        required this.name,
        required this.value,
        required this.machineId,
        required this.count,
        required this.status,
        required this.createdAt,
        required this.v,
    });

    factory JackpotHistoryModelData.fromJson(Map<String, dynamic> json) => JackpotHistoryModelData(
        id: json["_id"],
        name: json["name"],
        value: json["value"]?.toDouble(),
        machineId: json["machineId"],
        count: json["count"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

   
}
