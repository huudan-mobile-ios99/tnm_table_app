
class TimeModelList {
  final List<TimeModel> list;

  TimeModelList({required this.list});
  factory TimeModelList.fromJson(List<dynamic> json) {
    List<TimeModel> list =json.map((data) => TimeModel.fromJson(data)).toList();
    return TimeModelList(list: list);
  }
}




class TimeModel {
    String id;
    String timeModelId;
    int minutes;
    int seconds;
    int status;
    bool active;
    DateTime createdAt;
    DateTime updateAt;
    int v;

    TimeModel({
        required this.id,
        required this.timeModelId,
        required this.minutes,
        required this.seconds,
        required this.status,
        required this.active,
        required this.createdAt,
        required this.updateAt,
        required this.v,
    });

    factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
        id: json["_id"],
        timeModelId: json["id"],
        minutes: json["minutes"],
        seconds: json["seconds"],
        status: json["status"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        updateAt: DateTime.parse(json["updateAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": timeModelId,
        "minutes": minutes,
        "seconds": seconds,
        "status": status,
        "active": active,
        "createdAt": createdAt.toIso8601String(),
        "updateAt": updateAt.toIso8601String(),
        "__v": v,
    };
}