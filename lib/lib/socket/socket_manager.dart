import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._();
  factory SocketManager() {
    return _instance;
  }

  IO.Socket? _socket;
  late StreamController<List<Map<String, dynamic>>> _streamController;
  late StreamController<List<Map<String, dynamic>>> _streamController2;
  late StreamController<List<Map<String, dynamic>>> _streamControllerView;
  late StreamController<List<Map<String, dynamic>>> _streamControllerSetting;
  late StreamController<List<Map<String, dynamic>>> _streamControllerTime;
  late StreamController<List<Map<String, dynamic>>> _streamControllerJackpot; //from mongo
  late StreamController<List<Map<String, dynamic>>>  _streamControllerJackpotNumber; //from mysql
  late StreamController<List<Map<String, dynamic>>> _streamControllerJackpotNumber2; //from mysql
  late StreamController<List<Map<String, dynamic>>>_streamControllerDevice; //from mongodb data
    late StreamController<List<Map<String, dynamic>>>_streamControllerJackpotDrop; //from mongodb data

  IO.Socket? get socket => _socket;



  Stream<List<Map<String, dynamic>>> get dataStream => _streamController.stream;
  Stream<List<Map<String, dynamic>>> get dataStream2 =>  _streamController2.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamView => _streamControllerView.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamSetting => _streamControllerSetting.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamTime =>_streamControllerTime.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamJackpot =>_streamControllerJackpot.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamJackpotNumber =>_streamControllerJackpotNumber.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamJackpotNumber2 => _streamControllerJackpotNumber2.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamDevice => _streamControllerDevice.stream;
  Stream<List<Map<String, dynamic>>> get dataStreamJackpotDrop => _streamControllerJackpotDrop.stream;

  SocketManager._() {
    _streamController =  StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamController2 = StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerView = StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerSetting =  StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerTime =  StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerJackpot = StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerJackpotNumber = StreamController<List<Map<String, dynamic>>>.broadcast();
    _streamControllerJackpotNumber2 = StreamController<List<Map<String, dynamic>>>.broadcast();
    //stream device
    _streamControllerDevice =  StreamController<List<Map<String, dynamic>>>.broadcast();
    //jackpot drop
    _streamControllerJackpotDrop = StreamController<List<Map<String, dynamic>>>.broadcast();
  }

  void initSocket() {
    debugPrint('initSocket');
    _socket = IO.io(MyString.BASEURL, <String, dynamic>{
      // 'autoConnect': false,
      // 'transports': ['websocket'],
      'autoConnect': true, // Auto reconnect
      'reconnection': true, // Enable reconnections
      'reconnectionAttempts': 10, // Number of reconnection attempts
      'reconnectionDelay': 5000, // Delay between reconnections
      'transports': ['websocket'],
    });

    //EVENT DEVICE
    _socket?.on('eventDevice', (data) {
      // debugPrint('eventDevice JSON: $data');
      processDevice(data);
    });

    _socket?.on('eventFromServer', (data) {
      // debugPrint('eventFromServer log: $data');
      processData(data);
    });
    _socket?.on('eventFromServerMongo', (data) {
      // print('eventFromServerMongo log: $data');
      processData2(data);
    });

    //socket toggle view
    _socket?.on('eventFromServerToggle', (data) {
      // debugPrint('eventFromServerToggle log: $data');
      processDataToggle(data);
    });


    //TIME VIEW
    _socket?.on('eventTime', (data) {
      debugPrint('eventTime SocketManager $data');
      // debugPrint('eventTime SocketManager: $data');
      processDataTime(data);
    });

    //JACKPOT FROM MONGODB
    _socket?.on('eventJackpot', (data) {
      // debugPrint('eventJackpot log: $data');
      processJackpot(data);
    });


    //JACKPOT FROM MONGODB
    _socket?.on('eventJPDrop', (data) {
      // debugPrint('eventJPDrop log: $data');
      processJackpotDrop(data);
    });

    //JACKPOT FROM MYSQL
    _socket?.on('eventJackpotNumber', (data) {
      // debugPrint('eventJackpotNumber log: $data');
      // debugPrint('eventJackpotNumber log:');
      processJackpotNumber(data);
    });

    //JACKPOT FROM MYSQL
    _socket?.on('eventJackpot2Number', (data) {
      // debugPrint('eventJackpot2Number log: $data');
      processJackpot2Number(data);
    });



    //SETTING VIEW
    _socket?.on('eventSetting', (data) {
      // debugPrint("eventSetting socket.on");
      processDataSetting(data);
    });

    _socket?.connect();
  }

  void connectSocket() {
    _socket?.connect();
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket = null;
  }

//process data setting
  void processDataSetting(dynamic data) {
    for (var jsonData in data) {
          // debugPrint('processDataSetting JSON: $jsonData');
      try {
        // Create a Map to represent the display data
        Map<String, dynamic> data = {
          "_id": jsonData['_id'],
          "id": jsonData['id'],
          "round": jsonData['round'],
          "game": jsonData['game'],
          "note": jsonData['note'],
          "createdAt": jsonData['createdAt'],
          "updateAt": jsonData['updateAt'],
          "__v": jsonData['__v'],
        };
        _streamControllerSetting.add([data]);
      } catch (e) {
        debugPrint('Error parsing data setting: $e');
      }
    }
  }

//processDataTime
  void processDataTime(dynamic data) {
    debugPrint('processDataTime');
    for (var jsonData in data) {
          // debugPrint('processDataTime JSON: $jsonData');
      try {
        // Create a Map to represent the display data
        Map<String, dynamic> data = {
          "_id": jsonData['_id'],
          "id": jsonData['id'],
          "minutes": jsonData['minutes'],
          "seconds": jsonData['seconds'],
          "status": jsonData['status'],
          "active": jsonData['active'],
          "createdAt": jsonData['createdAt'],
          "updateAt": jsonData['updateAt'],
          "__v": jsonData['__v'],
        };
        _streamControllerTime.add([data]);
      } catch (e) {
        debugPrint('Error parsing data setting: $e');
      }
    }
  }

  void processData(dynamic data) {
    if (data is List<dynamic> && data.isNotEmpty) {
      if (data[0] is List<dynamic>) {
        List<dynamic> memberList = data[0];
        List rawData = data;
        List<List<dynamic>> formattedData = [memberList, ...rawData];
        List<Map<String, dynamic>> resultData = [];
        List<String> memberListAsString =
            memberList.map((member) => member.toString()).toList();

        for (int i = 1; i < formattedData.length; i++) {
          Map<String, dynamic> entry = {
            'member': memberListAsString,
            'data': formattedData[i].map((entry) {
              if (entry is num) {
                return entry.toDouble();
              }
              return entry;
            }).toList(),
          };
          resultData.add(entry);
        }
        // debugPrint("resultData: $resultData");
        _streamController.add(resultData);
      }
    }
  }

  void processJackpot(dynamic data) {
    debugPrint('access processJackpot');
    List<Map<String, dynamic>> jackpotList = [];

    for (var jsonData in data) {
      try {
        // Parse each jackpot item into a Map<String, dynamic> following your JackpotModelData structure
        Map<String, dynamic> jackpotMap = {
          "_id": jsonData['_id'],
          "id": jsonData['id'],
          "typeJackpot": jsonData['typeJackpot'],
          "name": jsonData['name'],
          "initValue": jsonData['initValue'],
          "startValue": jsonData['startValue'],
          "endValue": jsonData['endValue'],
          "createdAt": jsonData[
              'createdAt'], // This can remain a String or DateTime based on your requirement
          "hitDateTime": jsonData['hitDateTime'],
          "hitValue": jsonData['hitValue'],
          "machineId": jsonData['machineId'],
          "__v": jsonData['__v'],
        };

        jackpotList.add(jackpotMap);
      } catch (e) {
        debugPrint('Error parsing data jackpot: $e');
      }
    }

    // Add the List<Map<String, dynamic>> to the stream controller
    _streamControllerJackpot.add(jackpotList);
  }



  void processJackpotDrop(dynamic data) {
    // debugPrint('processJackpotDrop');
    for (var jsonData in data) {
      // debugPrint('processJackpotDrop JSON: $jsonData');
      try {
        // Create a Map to represent the display data
        Map<String, dynamic> data = {
          "_id": jsonData['_id'],
          "name": jsonData['name'],
            "value": jsonData['value'],
            "machineId":jsonData['machineId'],
            "count": jsonData['count'],
            "status": jsonData['status'],
          "createdAt": jsonData['createdAt'],
          "__v": jsonData['__v'],
        };
        _streamControllerJackpotDrop.add([data]);
      } catch (e) {
        debugPrint('Error parsing data jp drop: $e');
      }
    }
  }


  void processJackpotNumber(dynamic data) {
    // debugPrint('access processJackpotNumber $data');
    // Check if data is a map and contains the necessary fields
    if (data is Map<String, dynamic>) {
      try {
        Map<String, dynamic> jackpotMap = {
          "averageCredit": data['averageCredit'],
          "status": data['status'],
          "timeCount": data['timeCount'],
          "diff": data['diff'],
          "returnValue": data['returnValue'],
          "oldValue": data['oldValue'],
          "drop": data['drop'],
          "ip": data['ip'],
        };

        // Add the map directly to the stream (without a list)
        _streamControllerJackpotNumber.add([jackpotMap]);
      } catch (e) {
        debugPrint('Error parsing data jackpot number: $e');
      }
    } else {
      debugPrint(
          'Error: expected Map<String, dynamic> but received: ${data.runtimeType}');
    }
  }

  void processJackpot2Number(dynamic data) {
    // debugPrint('access processJackpot2Number $data');
    if (data is Map<String, dynamic>) {
      try {
        Map<String, dynamic> jackpotMap = {
          "averageCredit": data['averageCredit'],
          "status": data['status'],
          "timeCount": data['timeCount'],
          "diff": data['diff'],
          "returnValue": data['returnValue'],
          "oldValue": data['oldValue'],
          "drop": data['drop'],
          "ip": data['ip'],
        };

        _streamControllerJackpotNumber2.add([jackpotMap]);
      } catch (e) {
        debugPrint('Error parsing data jackpot 2 number: $e');
      }
    } else {
      debugPrint(
          'Error: expected Map<String, dynamic> but received: ${data.runtimeType}');
    }
  }

  void processData2(dynamic data) {
    final Map<String, dynamic>? jsonData = data as Map<String, dynamic>?;

    if (jsonData != null) {
      final List<dynamic>? dataList = jsonData['data'] as List<dynamic>?;
      final List<dynamic>? nameList = jsonData['name'] as List<dynamic>?;
      final List<dynamic>? numberList = jsonData['number'] as List<dynamic>?;
      final List<dynamic>? timeList = jsonData['time'] as List<dynamic>?;

      if (dataList != null && nameList != null) {
        final Map<String, dynamic> finalFormattedData = {
          'data': dataList,
          'name': nameList,
          'number': numberList,
          'time': timeList,
        };
        List<Map<String, dynamic>> listOfMaps = [finalFormattedData];
        _streamController2.add(listOfMaps);
      }
    }
  }

  void processDataToggle(dynamic data) {
    for (var jsonData in data) {
      try {
        // Parse the createdAt field as a DateTime object
        DateTime createdAt = DateTime.parse(jsonData['createdAt']);
        // Create a Map to represent the display data
        Map<String, dynamic> displayData = {
          // '_id': jsonData['_id'].toString(), // Convert ObjectId to string
          // 'id': jsonData['id'],
          'name': jsonData['name'],
          'enable': jsonData['enable'],
          'content': jsonData['content'],
          // 'createdAt': createdAt,
        };
        _streamControllerView.add([displayData]);
      } catch (e) {
        debugPrint('Error parsing datetime: $e');
      }
    }
  }

  void processDevice(dynamic data) {
  // debugPrint('ACCESS processDevice $data');
  List<Map<String, dynamic>> deviceList = [];
  for (var jsonData in data) {
    try {
      Map<String, dynamic> dataMap = {
        "_id": jsonData['_id'] as String, // Ensure _id is treated as a String
        "deviceId": jsonData['deviceId'] as String ?? "",
        "deviceName": jsonData['deviceName'] as String ?? "",
        "deviceInfo": jsonData['deviceInfo'] as String ?? "",
        "ipAddress": jsonData['ipAddress'] as String ?? "",
        "userAgent": jsonData['userAgent'] as String ?? "",
        "platform": jsonData['platform'] as String ?? "",
        "createdAt": jsonData['createdAt'],
        "__v": jsonData['__v'],
      };
      deviceList.add(dataMap);
    } catch (e) {
      debugPrint('Error parsing data device: $e');
    }
  }
  _streamControllerDevice.add(deviceList);
}


  void emitEventFromClient() {
    _socket?.emit('eventFromClient');
  }

  void emitEventFromClient2() {
    _socket?.emit('eventFromClient2');
  }

  Future<void> emitEventFromClientForce() async{
    socket!.emit('eventFromClient_force');
  }

  Future<void> emitEventFromClient2Force() async {
    socket!.emit('eventFromClient2_force');
  }


  void emitEventChangeLimitTopRanking(newLimit) {
    // Ensure newLimit is a valid value before emitting the event
    if (newLimit != 'undefined' && newLimit != null) {
      socket!.emit('changeLimitTopRanking', {newLimit});
    } else {
      debugPrint('Invalid newLimit value');
    }
  }

  void emitEventChangeLimitRealTimeRanking(newLimit) {
    // Ensure newLimit is a valid value before emitting the event
    if (newLimit != 'undefined' && newLimit != null) {
      socket!.emit('changeLimitRealTimeRanking', {newLimit});
    } else {
      debugPrint('Invalid newLimit value');
    }
  }

  //update vegas prize
  void updateJackpotSettings(Map<String, dynamic> newSettings) {
    socket!.emit('updateJackpotSetting', newSettings);
  }

  //update lucky prize
  void updateJackpot2Settings(Map<String, dynamic> newSettings) {
    socket!.emit('updateJackpot2Setting', newSettings);
  }

  //toglge view data or top ranking
  void emitToggleClient() {
    socket!.emit('emitToggleDisplay');
  }

  //togge view to see only real ranking or both
  void emitToggleRealTopClient() {
    socket!.emit('emitToggleDisplayRealTop');
  }

  //emit data setting
  void emitSetting() {
    socket!.emit('emitSetting');
  }

  //emit data setting
  void emitSettingGame() {
    socket!.emit('emitSetting');
  }

  //emit data setting
  void emitDevice() {
    debugPrint('called emitDevice');
    socket!.emit('emitDevice');
  }

  //emit data time
  void emitTime() {
    socket!.emit('emitTime');
  }

  void emitJackpot() {
    socket!.emit('emitJackpot');
  }

  void emitJackpotDrop() {
    socket!.emit('emitJPDrop');
  }

  void emitJackpotNumber() {
    socket!.emit('emitJackpotNumber');
  }

  void emitJackpot2Number() {
    socket!.emit('emitJackpot2Number');
  }

  void emitJackpotNumberInit() {
    debugPrint('emitJackpotNumberInit');
    socket!.emit('emitJackpotNumberInitial');
  }

  void emitJackpot2NumberInit() {
    debugPrint('emitJackpot2NumberInit');
    socket!.emit('emitJackpot2NumberInitial');
  }

  // Emit the 'updateTime' event with the updated time data
  void emitUpdateTime(Map<String, dynamic> updateData) {
    _socket?.emit('updateTime', updateData);
  }
}
