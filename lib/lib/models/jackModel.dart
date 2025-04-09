// To parse this JSON data, do
//
//     final jackpotModel = jackpotModelFromJson(jsonString);

import 'dart:convert';

JackpotModel jackpotModelFromJson(String str) => JackpotModel.fromJson(json.decode(str));


class JackpotModel {
    bool status;
    String message;
    List<JackpotModelData> data;

    JackpotModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory JackpotModel.fromJson(Map<String, dynamic> json) => JackpotModel(
        status: json["status"],
        message: json["message"],
        data: List<JackpotModelData>.from(json["data"].map((x) => JackpotModelData.fromJson(x))),
    );

  
}

class JackpotModelData {
    String id;
    String datumId;
    int typeJackpot;
    String name;
    int initValue;
    int startValue;
    int endValue;
    DateTime createdAt;
    DateTime hitDateTime;
    double hitValue;
    int machineId;
    int v;

    JackpotModelData({
        required this.id,
        required this.datumId,
        required this.typeJackpot,
        required this.name,
        required this.initValue,
        required this.startValue,
        required this.endValue,
        required this.createdAt,
        required this.hitDateTime,
        required this.hitValue,
        required this.machineId,
        required this.v,
    });

    factory JackpotModelData.fromJson(Map<String, dynamic> json) => JackpotModelData(
        id: json["_id"],
        datumId: json["id"],
        typeJackpot: json["typeJackpot"],
        name: json["name"],
        initValue: json["initValue"],
        startValue: json["startValue"],
        endValue: json["endValue"],
        createdAt: DateTime.parse(json["createdAt"]),
        hitDateTime: DateTime.parse(json["hitDateTime"]),
        hitValue: json["hitValue"]?.toDouble(),
        machineId: json["machineId"],
        v: json["__v"],
    );

    
}
