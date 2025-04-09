
class SettingModelList {
  final List<SettingModel> list;

  SettingModelList({required this.list});
  factory SettingModelList.fromJson(List<dynamic> json) {
    List<SettingModel> list =json.map((data) => SettingModel.fromJson(data)).toList();
    return SettingModelList(list: list);
  }
}



class SettingModel {
    String id;
    String settingModelId;
    int round;
    int game;
    String note;
    DateTime createdAt;
    DateTime updateAt;
    int v;

    SettingModel({
        required this.id,
        required this.settingModelId,
        required this.round,
        required this.game,
        required this.note,
        required this.createdAt,
        required this.updateAt,
        required this.v,
    });

    factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        id: json["_id"],
        settingModelId: json["id"],
        round: json["round"],
        game: json["game"],
        note: json["note"],
        createdAt: DateTime.parse(json["createdAt"]),
        updateAt: DateTime.parse(json["updateAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": settingModelId,
        "round": round,
        "game": game,
        "note": note,
        "createdAt": createdAt.toIso8601String(),
        "updateAt": updateAt.toIso8601String(),
        "__v": v,
    };
}
