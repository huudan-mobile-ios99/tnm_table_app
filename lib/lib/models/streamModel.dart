
class StreamModel {
    bool status;
    String message;
    List<StreamDataModel> data;

    StreamModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory StreamModel.fromJson(Map<String, dynamic> json) => StreamModel(
        status: json["status"],
        message: json["message"],
        data: List<StreamDataModel>.from(json["data"].map((x) => StreamDataModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class StreamDataModel {
    String id;
    String datumId;
    String name;
    String url;
    bool active;
    DateTime createdAt;
    DateTime updateAt;
    int v;

    StreamDataModel({
        required this.id,
        required this.datumId,
        required this.name,
        required this.url,
        required this.active,
        required this.createdAt,
        required this.updateAt,
        required this.v,
    });

    factory StreamDataModel.fromJson(Map<String, dynamic> json) => StreamDataModel(
        id: json["_id"],
        datumId: json["id"],
        name: json["name"],
        url: json["url"],
        active: json["active"],
        createdAt: DateTime.parse(json["createdAt"]),
        updateAt: DateTime.parse(json["updateAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": datumId,
        "name": name,
        "url": url,
        "active": active,
        "createdAt": createdAt.toIso8601String(),
        "updateAt": updateAt.toIso8601String(),
        "__v": v,
    };
}
