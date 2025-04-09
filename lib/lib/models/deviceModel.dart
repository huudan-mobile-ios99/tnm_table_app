class DeviceModel {
    bool status;
    String message;
    int totalResult;
    List<DeviceModelData> data;


    DeviceModel({
        required this.status,
        required this.message,
        required this.totalResult,
        required this.data,

    });

    factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        status: json["status"],
        message: json["message"],
        totalResult: json["totalResult"],

        data: List<DeviceModelData>.from(json["data"].map((x) => DeviceModelData.fromJson(x))),
    );

}

class DeviceModelList{
    final List<DeviceModelData> list;

  DeviceModelList({required this.list});
  factory DeviceModelList.fromJson(List<dynamic> json) {
    List<DeviceModelData> list =json.map((data) => DeviceModelData.fromJson(data)).toList();
    return DeviceModelList(list: list);
  }
}

class DeviceModelData {
    String id;
    String deviceId;
    String deviceName;
    String deviceInfo;
    DateTime createdAt;
    String ipAddress;
    String userAgent;
    String platform;
    int v;

    DeviceModelData({
        required this.id,
        required this.deviceId,
        required this.deviceName,
        required this.deviceInfo,
        required this.createdAt,
        required this.v,

        required this.ipAddress,
        required this.userAgent,
        required this.platform,
    });

    factory DeviceModelData.fromJson(Map<String, dynamic> json) => DeviceModelData(
        id: json['_id'] as String,
        deviceId: json['deviceId'] as String, // Ensure this matches the backend data
        deviceName: json['deviceName'] as String,
        deviceInfo: json['deviceInfo'] as String,

        createdAt: DateTime.parse(json['createdAt']),
        v: json["__v"],
        ipAddress : json['ipAddress'] as String,
        userAgent: json['userAgent'] as String ,
        platform:json['platform'] as String,
    );
}
