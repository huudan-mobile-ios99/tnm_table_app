import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:tournament_client/lib/models/deviceModel.dart';
import 'package:tournament_client/lib/models/jackModel.dart';
import 'package:tournament_client/lib/models/jackpotDropModel.dart';
import 'package:tournament_client/lib/models/streamModel.dart';
import 'package:tournament_client/lib/models/timeModel.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/lib/models/roundModel.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/lib/models/roundModelRealtime.dart';
import 'package:tournament_client/screen/admin/model/rankingList.dart';
import 'package:tournament_client/xpage/setup/model/settingslot.model.dart';

class ServiceAPIs {
  Dio dio = Dio();
  final int receiveAndSendTimeout = 15000;
  // NetworkCache networkCache = NetworkCache();

  Future fetchInit() async {}
  //List report
  Future<ListStationModel?> listStationData() async {
    try {
      final response = await dio.get(
        MyString.list_station,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // debugPrint('${response.data}');
      return ListStationModel.fromJson(response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  //update member station
  Future<dynamic> updateMemberStation({ip, member}) async {
    final Map<String, dynamic> body = {"ip": ip, "member": member};
    try {
      final response = await dio.post(
        MyString.update_member_station,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<List<List<double>>> fetchData() async {
    final response = await http.get(Uri.parse(MyString.list_data_station));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<List<double>> result = [];

      for (var subArray in data) {
        List<double> creditValues = (subArray as List<dynamic>)
            .map<double>((value) => value.toDouble())
            .toList();
        result.add(creditValues);
      }

      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<List<double>>> getData() async {
    final response = await dio.get(
      MyString.list_data_station,
      options: Options(
        contentType: Headers.jsonContentType,
        // receiveTimeout: receiveAndSendTimeout,
        // sendTimeout: receiveAndSendTimeout,
        // followRedirects: false,
        // validateStatus: (status) {
        //   return true;
        // },
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print('response data from request: ${response.data}');
    // final List<List<double>> list = response.data;
    // print('reponse: $list');
    return response.data;
  }

  //List JP History
  Future<JackpotHistoryModel?> listJPHistory([int startIndex = 0,int postLimit = 30]) async {
    debugPrint("listJPHistory: startIndex=$startIndex, postLimit=$postLimit");
    try {
      final response = await dio.get(
        MyString.jackpot_history,
        queryParameters: {'start': '$startIndex', 'limit': '$postLimit'},
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // debugPrint("jackpotData: ${response.data}");

      late final jackpotData = JackpotHistoryModel.fromJson(response.data);
      debugPrint("listJPHistory url: ${MyString.jackpot_history}\nTotal results: ${jackpotData.data.length}");
      return jackpotData;
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  //List report
  Future<RankingModel?> listRanking() async {
    try {
      final response = await dio.get(
        MyString.list_ranking,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return RankingModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  //List rounds
  Future<RoundModel?> listRounds() async {
    try {
      final response = await dio.get(
        MyString.list_round,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return RoundModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

//create new ranking
  //List report
  Future<dynamic> createRanking({customer_name, customer_number, point}) async {
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
      "point": point,
    };
    try {
      final response = await dio.post(
        MyString.create_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //create new round
  Future<dynamic> createRound(
      // {required List<Ranking>? rankings}
      ) async {
    // Map<String, dynamic> body = {
    //   "rankings": rankings,
    // };
    try {
      final response = await dio.post(
        MyString.create_round,
        data: null,
        // data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //create new round realtime
  Future<dynamic> createRoundRealTime() async {
    try {
      final response = await dio.get(
        MyString.create_round_realtime,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //ADD ALL REALTIME RANKING
  Future<dynamic> addRealTimeRanking() async {
    debugPrint('addRealTimeRanking');
    try {
      final response = await dio.post(
        MyString.add_ranking_realtime,
        data: null,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //update display station data
  Future<dynamic> updateDisplayStatus({ip, display}) async {
    Map<String, dynamic> body = {
      "ip": ip,
      "display": display,
    };
    try {
      final response = await dio.post(
        MyString.update_station_status,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updateRanking({customer_name, customer_number, point}) async {
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
      "point": point
    };
    try {
      final response = await dio.put(
        MyString.update_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      debugPrint(response.data);
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }

  Future<dynamic> updateRankingById({customer_number, point, id}) async {
    Map<String, dynamic> body = {
      "customer_number": customer_number,
      "point": point,
      "_id": id
    };
    try {
      final response = await dio.put(
        MyString.update_ranking_by_id,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

//delete report by customer_name & customer_number
  Future<dynamic> deleteRanking({customer_name, customer_number}) async {
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
    };
    try {
      final response = await dio.delete(
        MyString.delete_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

//delete report by customer_name & customer_number
  Future<dynamic> deleteRankingById({id}) async {
    try {
      final response = await dio.delete(
        MyString.delete_ranking_byid(id),
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> createStation({machine, member}) async {
    Map<String, dynamic> body = {
      "machine": machine,
      "member": member,
      "bet": 0,
      "credit": 0,
      "connect": 0,
      "status": 0,
      "aft": 0,
      "lastupdate": DateTime.now().toString(),
      "display": 0
    };
    try {
      final response = await dio.post(
        MyString.create_station,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<SettingSlotList?> findSettings() async {
    debugPrint('findSettings');
    try {
      final response = await dio.get(
        MyString.settings,
        options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // debugPrint('findSettings: ${response.data}');
      // return (response.data);
      return SettingSlotList.fromJson(response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  //Update status all station or disable all
  Future<dynamic> updateStatusAll({required int status}) async {
    Map<String, dynamic> body = {
      "status": status,
    };
    try {
      final response = await dio.post(
        MyString.update_status_all,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }

  Future<dynamic> updateSetting(
      {required String remaintime,
      required int remaingame,
      required int minbet,
      required int maxbet,
      required int run,
      required String lastupdate,
      required int gamenumber,
      required String roundtext,
      required String gametext,
      required int buyin}) async {
    debugPrint('updateSetting');
    Map<String, dynamic> boyd = {
      "remaintime": remaintime,
      "remaingame": remaingame,
      "minbet": minbet,
      "maxbet": maxbet,
      "run": run,
      "lastupdate": lastupdate,
      "gamenumber": gamenumber,
      "roundtext": roundtext,
      "gametext": gametext,
      "buyin": buyin
      // "remaintime": "00:03:26",
      // "remaingame": 7,
      // "minbet": 1,
      // "maxbet": 50,
      // "run": 1,
      // "lastupdate": "2024-09-04T06:29:09.000Z",
      // "gamenumber": 224867,
      // "roundtext": "5",
      // "gametext": "Vegas",
      // "buyin": 0
    };
    try {
      final response = await dio.put(
        MyString.setting_update,
        data: boyd,
        options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      debugPrint('updateSetting Res: ${response.data}');
      // return (response.data);
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }
  Future<dynamic> updateSettingGame(
      {
      required int game,
      required int round,
      required String note,
     }) async {
    debugPrint('updateSetting');
    Map<String, dynamic> body = {
        "id":"25f80dc9-7c3b-4386-8e16-7410c04ccd01","round":round,"game":game,"note":note
    };
    try {
      final response = await dio.put(
        MyString.setting_update_game,
        data: body,
        options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      debugPrint('updateSettingGAME Res: ${response.data}');
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }


  Future<dynamic> updateSettingTableGame(
      {required String game,
      required String round,
      }) async {
    debugPrint('updateSettingTableGame');
    Map<String, dynamic> boyd = {
      "game": game,
      "round": round,
    };
    try {
      final response = await dio.put(
        MyString.setting_update,
        data: boyd,
        options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      debugPrint('updateSetting Talbe Game Res: ${response.data}');
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return null;
  }





  Future<dynamic> deleteStation({machine, member}) async {
    Map<String, dynamic> body = {
      "machine": machine,
      "member": member,
    };
    try {
      final response = await dio.delete(
        MyString.delete_station,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> deleteRankingAllAndAddDefault() async {
    try {
      final response = await dio.delete(
        MyString.delete_ranking_all_and_add,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }

  Future<List<Ranking>> fetchRanking([int startIndex = 0, postLimit]) async {
    const postLimit = 20;
    try {
      debugPrint('_fetchRaking');
      final dio = Dio();
      final response = await dio.get(
        MyString.list_ranking_data, // Use http instead of https if it's not secured
        queryParameters: {'start': '$startIndex', 'limit': '$postLimit'},
      );
      if (response.statusCode == 200) {
        debugPrint('200 status');
        final body = response.data as List;
        return body.map((dynamic json) {
          final map = json as Map<String, dynamic>;
          return Ranking(
            id: map['_id'] as String?,
            customerName: map['customer_name'] as String?,
            customerNumber: map['customer_number'] as String?,
            point: (map['point'] as num?)?.toDouble(),
            createdAt: map['createdAt'] as String?,
            v: map['_v'] as int?,
          );
        }).toList();
      } else {
        debugPrint('something wrong');
        return [];
      }
    } catch (e) {
      debugPrint('something went wrong $e');
      return [];
    }
  }
//end service APIs here

//export data excel
  Future exportDataExcel() async {
    final response = await dio.get(
      MyString.export_round,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return (response.data);
  }

//export data excel
  Future exportDataExcelRealTime() async {
    final response = await dio.get(
      MyString.export_round_realtime,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return (response.data);
  }

  //update display status
  Future<dynamic> updateDisplayTopRankingStatus(
      {required String id, String? name, required bool? enable}) async {
    Map<String, dynamic> body = {
      "name": "display_top_ranking",
      "enable": enable,
      "content": "display_top_ranking_content"
    };
    final response = await dio.put(
      MyString.update_display(id),
      data: body,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return (response.data);
  }

  //update display status
  Future<dynamic> updateDisplayTopRealRankingStatus(
      {required String id, String? name, required bool? enable}) async {
    Map<String, dynamic> body = {
      "name": "display view real/top",
      "enable": enable,
      "content": "display view real/top"
    };
    final response = await dio.put(
      MyString.update_display_realtop(id),
      data: body,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return (response.data);
  }

  //show list display status
  Future<dynamic> listDisplayTopRankingStatus() async {
    final response = await dio.get(
      MyString.list_display,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('${response.data}');
    return response.data;
  }

  //List rounds realtime ranking
  Future<ListRoundRealTimeModel?> listRoundRealTime() async {
    final response = await dio.get(
      MyString.list_round_realtime,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print(response.data);
    return ListRoundRealTimeModel.fromJson(response.data);
  }

  Future login({required String username, required password}) async {
    Map<String, dynamic> body = {'username': username, "password": password};
    final response = await dio.post(
      MyString.login,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    print('${response.data}');
    return (response.data);
  }

  //TIME APIs
  Future<TimeModelList?> getLatestActiveTime() async {
    final response = await dio.get(
      MyString.get_latest_active_time,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('getLatestActiveTime: ${response.data}');
    return TimeModelList.fromJson(response.data);
  }

  Timer? _debounceRequestCall;

  //UPDATE TIME APIs
  Future<dynamic> updateTimeByID(
      {required String id,
      required int minutes,
      required int seconds,
      required int status}) async {
    Map<String, dynamic> body = {
      "id": id,
      "minutes": minutes,
      "seconds": seconds,
      "status": status
    };
    if (_debounceRequestCall?.isActive ?? false) _debounceRequestCall?.cancel();
    _debounceRequestCall = Timer(const Duration(seconds: 1), () async {
      Map<String, dynamic> body = {
        "id": id,
        "minutes": minutes,
        "seconds": seconds,
        "status": status
      };
      final response = await dio.put(
        MyString.update_time_by_id,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      debugPrint('updateTimeByID APIs: ${response.data['message']}');
      return (response.data);
    });
    // Return some placeholder value if you need to return immediately
    return Future.value(null);
  }

  //UPDATE TIME APIs
  Future<dynamic> updateTimeLatest(
      {int? minutes, int? seconds, required int status}) async {
    Map<String, dynamic> body = {
      "minutes": minutes,
      "seconds": seconds,
      "status": status
    };
    final response = await dio.put(
      MyString.update_time_latest,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('updateTimeByID: ${response.data}');
    return (response.data);
  }

  //STREAM GET ALL
  Future<StreamModel?> getStreamAll() async {
    final response = await dio.get(
      MyString.get_stream_all,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('getStreamAll: ${response.data}');
    return StreamModel.fromJson(response.data);
  }

  //STREAM GET ALL
  Future<JackpotModel?> getJackpotAll() async {
    final response = await dio.get(
      MyString.get_jackpot_all,
      options: Options(
        contentType: Headers.jsonContentType,
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('getJackpotAll: ${response.data}');
    return JackpotModel.fromJson(response.data);
  }


  //CREATE DEVICE

  Future<dynamic> createNewDevice({
    required String userAgent, required String platform,
    required String ipAddress,required String deviceId,required String deviceName, required String deviceInfo}
      ) async {
    Map<String, dynamic> body = {
      "deviceId":deviceId,
      "deviceName":deviceName,
      "deviceInfo":deviceInfo,
      "ipAddress":ipAddress,
      "userAgent":userAgent,"platform":platform,
    };
    try {
      final response = await dio.post(
        MyString.CREATE_NEW_DEVICE,
        data: body,
        // data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: receiveAndSendTimeout,
          sendTimeout: receiveAndSendTimeout,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return (response.data);
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }

  //List Device All

  //show list member all
  Future<DeviceModel> listDevicesAll() async {
    debugPrint('API ListDeviceAll  ${MyString.LIST_DEVICE_ALL}');
    final response = await dio.get(
      MyString.LIST_DEVICE_ALL,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('${response.data}');
    return DeviceModel.fromJson(response.data);
  }

//Delete Device by _id
  Future<dynamic> deleteDeviceById(id) async {
    debugPrint('API deleteDeviceById  ${MyString.delete_device_by_id(id)}');
    final response = await dio.delete(
      MyString.delete_device_by_id(id),
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('${response.data}');
    return (response.data);
  }
 //Update Device by _id
  Future<dynamic> updatedeviceByID({required id,required deviceName,required deviceInfo}) async {
    debugPrint('API updatedeviceByID  ${MyString.update_device_by_id(id)}');
    final Map<String,dynamic> data = {
      "deviceName":deviceName,
      "deviceInfo":deviceInfo
    };
    final response = await dio.put(
      MyString.update_device_by_id(id),
      data: data,
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint('${response.data}');
    return (response.data);
  }




  //Delete JP Drop by _id
  Future<dynamic> deleteJPDropById({required id}) async {
    debugPrint('API deleteJPDropById  ${MyString.delete_jackpot_by_id(id)}');
    final response = await dio.delete(
      MyString.delete_jackpot_by_id(id),
      options: Options(
        receiveTimeout: receiveAndSendTimeout,
        sendTimeout: receiveAndSendTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return (response.data);
  }



}
