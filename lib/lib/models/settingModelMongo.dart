
class SettingModelMongoList {
  final List<SettingModelMongo> list;

  SettingModelMongoList({required this.list});
  factory SettingModelMongoList.fromJson(List<dynamic> json) {
    List<SettingModelMongo> list =json.map((data) => SettingModelMongo.fromJson(data)).toList();
    return SettingModelMongoList(list: list);
  }
}



class SettingModelMongo {
    String id;
    String settingModelId;
    int round;
    int game;
    String note;
    DateTime createdAt;
    DateTime updateAt;
    int v;

    SettingModelMongo({
        required this.id,
        required this.settingModelId,
        required this.round,
        required this.game,
        required this.note,
        required this.createdAt,
        required this.updateAt,
        required this.v,
    });

    factory SettingModelMongo.fromJson(Map<String, dynamic> json) => SettingModelMongo(
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
