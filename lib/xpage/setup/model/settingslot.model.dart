
class SettingSlotList{
  final List<SettingSlot> list;
  SettingSlotList({required this.list});
  factory SettingSlotList.fromJson(List<dynamic> json) {
    List<SettingSlot> list = json.map((data) => SettingSlot.fromJson(data)).toList();
    return SettingSlotList(list: list);
  }
}


class SettingSlot {
    String? remaintime;
    int? remaingame;
    int? minbet;
    int? maxbet;
    int? run;
    DateTime? lastupdate;
    int? gamenumber;
    String? roundtext;
    String? gametext;
    int? buyin;

    SettingSlot({
        this.remaintime,
        this.remaingame,
        this.minbet,
        this.maxbet,
        this.run,
        this.lastupdate,
        this.gamenumber,
        this.roundtext,
        this.gametext,
        this.buyin,
    });

    factory SettingSlot.fromJson(Map<String, dynamic> json) => SettingSlot(
        remaintime: json["remaintime"] ?? '',
        remaingame: json["remaingame"] ?? 0,
        minbet: json["minbet"] ?? 0,
        maxbet: json["maxbet"] ?? 0,
        run: json["run"] ?? 0,
        lastupdate: json["lastupdate"] != null ? DateTime.parse(json["lastupdate"]) : DateTime.now(),
        gamenumber: json["gamenumber"] ?? 0,
        roundtext: json["roundtext"] ?? '',
        gametext: json["gametext"] ?? '',
        buyin: json["buyin"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "remaintime": remaintime,
        "remaingame": remaingame,
        "minbet": minbet,
        "maxbet": maxbet,
        "run": run,
        "lastupdate": lastupdate?.toIso8601String(),
        "gamenumber": gamenumber,
        "roundtext": roundtext,
        "gametext": gametext,
        "buyin": buyin,
    };
}