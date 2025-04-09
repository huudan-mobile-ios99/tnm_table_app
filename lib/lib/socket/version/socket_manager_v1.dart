import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManagerV1 {
  static final SocketManagerV1 _instance = SocketManagerV1._();
  factory SocketManagerV1() {
    return _instance;
  }

  IO.Socket? _socket;

  late StreamController<List<Map<String, dynamic>>>_streamControllerDevice; //from mongodb data
  IO.Socket? get socket => _socket;

  Stream<List<Map<String, dynamic>>> get dataStreamDevice => _streamControllerDevice.stream;


  SocketManagerV1._() {
    //stream device
    _streamControllerDevice = StreamController<List<Map<String, dynamic>>>.broadcast();
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
      debugPrint('eventDevice log: $data');
      processDevice(data);
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





  void processDevice(dynamic data) {
  // debugPrint('access processDevice socketmanagerV1');
  List<Map<String, dynamic>> deviceList = [];

  for (var jsonData in data) {
    try {
      // Ensure _id is always treated as a String
      Map<String, dynamic> dataMap = {
        "_id": jsonData['_id'], // Explicitly convert _id to String
        "deviceId": jsonData['deviceId'],
        "deviceName": jsonData['deviceName'],
        "deviceInfo": jsonData['deviceInfo'] ?? '',
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


}
