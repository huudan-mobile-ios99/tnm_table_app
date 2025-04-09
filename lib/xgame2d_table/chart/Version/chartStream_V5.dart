// import 'dart:async';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/functions.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chartScreen.dart';
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/utils/mycolors.dart';

// class ChartStreamPagev5 extends StatefulWidget {
//   const ChartStreamPagev5({Key? key}) : super(key: key);
//   @override
//   State<ChartStreamPagev5> createState() => _ChartStreamPagev5State();
// }

// class _ChartStreamPagev5State extends State<ChartStreamPagev5> {
//   @override

//   late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
//   late final SocketManager mySocket = SocketManager();
//   late Stream<List<Map<String, dynamic>>> _creditStream;
//   late Stream<List<Map<String, dynamic>>> _throttledStream;
//     late StreamSubscription<List<Map<String, dynamic>>> streamSubscription;


//   final int durationthrottled = 1000;
//   late Timer _timer;


//   // Define global variables
//   List<int> members = [];
//   List<int> initialChips = [];
//   List<int> nextChips= [];
//   List<int> inputNumber=[];
//   List<int> valueDislay=[];
//   List<int> valueDisplayPrev=[];

//   @override
//   void initState() {
//     // super.initState();
//     // mySocket.initSocket();
//     // _creditStream = mySocket.dataStream;

//     super.initState();
//     mySocket.initSocket();

//     // Apply throttling to incoming socket data
//     _throttledStream = mySocket.dataStream
//         .debounceTime(const Duration(milliseconds: 1000)) // Throttle updates every 1s
//         .distinct(); // Emit only when data changes

//     // Listen to the throttled stream
//     streamSubscription = _throttledStream.listen((data) {
//       if (data.isNotEmpty) {
//         arrangeDataSkip(data, [1, 2, 3, 4]);
//         streamController.add(data);
//       }
//     });
//   }


//   @override
//   void dispose() {
//     mySocket.disposeSocket();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     final heightItem = height/5.15;
//     final widthItem = width/5.25;

//     //POSITON OF CHIP INITIAL FOR PAGE GAME 2D
//     final List<double> positionXs = [
//       widthItem*1.55, //#1
//       widthItem*0.905, //#3
//       widthItem*1.025,//#5
//       widthItem*0.135,//#4
//       -widthItem/2,//#2
//       ];//HORIZONTAL
//     final List<double> positionYs = [
//       heightItem*1.625,
//       heightItem*3.35,
//       heightItem*4.45,
//       heightItem*3.35,
//       heightItem*1.625//#2
//       ]; //VERTICAL

//     return StreamBuilder<List<Map<String, dynamic>>>(
//         stream: mySocket.dataStream,
//         // stream: _throttledStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final List<Map<String, dynamic>>? dataList = snapshot.data;
//           if (dataList == null || dataList.isEmpty) {
//             return const Text('No Data Found');
//           }

//           final List<double> positionXCombined = syncDefautLists(positionXs, valueDislay);
//           final List<double> positionYCombined = syncDefautLists(positionYs, valueDislay);

//             // arrangeDataSkip(dataList!,[1,2,3,4]);
//             if (snapshot.data!.isEmpty ||
//                 snapshot.data == null ||
//                 snapshot.data == []) {
//                 return const Text('No Data Found');
//             }



//             // Dispatch event to update Bloc state
//             context.read<ChartStreamBloc>().add(UpdateChartDataEvent(
//                     inputNumbers: inputNumber,
//                     initialChips: initialChips,
//                     nextChips: nextChips,
//                     valueDisplay:valueDislay,
//                     valueDisplayPrev:valueDisplayPrev,
//                     members:members,
//                     positionX:positionXs,
//                     positionY:positionYs,

//             ));

//            return ChartScreen(
//              inputNumbers: inputNumber,
//              initialChips: initialChips,
//              nextChips: nextChips,
//              members:members,
//              positionXList:positionXCombined,
//              positionYList: positionYCombined,
//              valueDisplay:valueDislay,
//              valueDisplayPrev:valueDisplayPrev,
//            );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator( strokeWidth: 1, color: MyColor.white),
//             );
//           }
//         },
//     );
//   }



//  void  arrangeData(List<Map<String, dynamic>> dataList) async{
//   List<int> membersOrigin = dataList[0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
//   List<dynamic> rawData = dataList[1]['data'];

//   debugPrint('Original membersOrigin: $membersOrigin');
//   debugPrint('Original RawData: $rawData');

//   // Extract the first list (keys) from rawData
//   List<int> keys = List<int>.from(rawData[0]);

//   // Create a list of tuples (key, member, data1, data2) for sorting
//    List<Map<String, dynamic>> combined = List.generate(keys.length, (index) {
//     return {
//       'key': keys[index],
//       'member': membersOrigin[index],
//       'data1': (rawData[1][index] as num).round().toInt(), // Ensure int conversion
//       'data2': (rawData[2][index] as num).round().toInt(), // Ensure int conversion
//     };
//   });

//   // Sort by key in ascending order
//    combined.sort((a, b) => a['key'].compareTo(b['key']));

//   // Extract sorted values
//   inputNumber = combined.map((e) => e['key'] as int).toList();
//   members = combined.map((e) => e['member'] as int).toList();
//   initialChips = transformAndTruncateRange( combined.map((e) => e['data1'] as int).toList());
//   nextChips =  transformAndTruncateRange( combined.map((e) => e['data2'] as int).toList());
//   valueDislay = transformAndRoundOriginal(combined.map((e) => (e['data2'] as int).toInt()).toList());
//   valueDisplayPrev = transformAndRoundOriginal(combined.map((e) => (e['data1'] as int).toInt()).toList());

//   // Update rawData
//   rawData[0] = inputNumber;
//   rawData[1] = initialChips;
//   rawData[2] = nextChips;

//   // debugPrint('inputNumber $inputNumber Sorted Keys:');
//   // debugPrint('Members Sorted : $members');
//   // debugPrint('initialChips Sorted Data[1]: $initialChips');
//   // debugPrint('nextChips Sorted Data[2]: $nextChips');
//   // debugPrint('valueDisplay & valueDisplayPRe: $nextChips');
// }





// void arrangeDataSkip(List<dynamic> dataList, List<int> skipList) {
//   List<int> membersOrigin = dataList[0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
//   List<dynamic> rawData = dataList[1]['data'];

//   List<int> keys = List<int>.from(rawData[0]);

//   // Create combined list
//   List<Map<String, dynamic>> combined = List.generate(keys.length, (index) {
//     return {
//       'key': keys[index],
//       'member': membersOrigin[index],
//       'data1': (rawData[1][index] as num).round().toInt(),
//       'data2': (rawData[2][index] as num).round().toInt(),
//     };
//   });

//   // Filter out keys that are in skipList
//   combined.removeWhere((item) => skipList.contains(item['key']));

//   // Sort remaining data by key
//   combined.sort((a, b) => a['key'].compareTo(b['key']));

//   // Update lists with sorted and filtered data
//   inputNumber = combined.map((e) => e['key'] as int).toList();
//   members = combined.map((e) => e['member'] as int).toList();
//   initialChips = transformAndTruncateRange(combined.map((e) => e['data1'] as int).toList(),);
//   nextChips = transformAndTruncateRange(combined.map((e) => e['data2'] as int).toList(),);
//   valueDislay = transformAndRoundOriginal(combined.map((e) => e['data2'] as int).toList());
//   valueDisplayPrev = transformAndRoundOriginal(combined.map((e) => e['data1'] as int).toList());

//   // Update rawData
//   rawData[0] = inputNumber;
//   rawData[1] = initialChips;
//   rawData[2] = nextChips;

//   // Debugging Output
//   // debugPrint('inputNumber: $inputNumber Members Sorted: $members initialChips Sorted : $initialChips nextChips Sorted: $nextChips valueDisplay $valueDislay  valueDisplayPrev: $valueDisplayPrev');

// }
// }



