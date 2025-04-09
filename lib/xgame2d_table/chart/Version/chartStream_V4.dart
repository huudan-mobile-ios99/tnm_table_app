// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/functions.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chartScreen.dart';
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/utils/mycolors.dart';

// class ChartStreamPageV4 extends StatefulWidget {
//   const ChartStreamPageV4({Key? key}) : super(key: key);
//   @override
//   State<ChartStreamPageV4> createState() => _ChartStreamPageV4State();
// }

// class _ChartStreamPageV4State extends State<ChartStreamPageV4> {
//   @override

//   late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
//   late final SocketManager mySocket = SocketManager();
//   late Stream<List<Map<String, dynamic>>> _creditStream;
//   final int durationthrottled = 1000;

//   late Timer _timer;

//   // Define global variables
//   List<int> members = [];
//   List<int> initialChips = [];
//   List<int> nextChips= [];
//   List<int> inputNumber=[];
//   List<int> valueDislay=[];
//   List<int> valueDisplayPrev=[];

//   //default value for testing
//   // List<int> members = [1,2,3,4,5,];
//   // List<int> inputNumber=[1,2,3,4,5];
//   // List<int> initialChips = [0,0,0,0,0];
//   // late List<int> nextChips=[0,0,0,0,0];
//   // List<int> valueDisplayPrev=[0,0,0,0,0];
//   // List<int> valueDislay=[1,2,3,4,5];



//   @override
//   void initState() {
//     super.initState();
//     mySocket.initSocket();
//     _creditStream = mySocket.dataStream;

//     // _startUpdatingData();
//   }
//   // void _startUpdatingData() {
//   //   debugPrint('run startUPdate data every 5s');
//   //   _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//   //     setState(() {
//   //       valueDislay = _generateRandomChips();
//   //       debugPrint('valueDisplay: $valueDislay');
//   //     });
//   //   });
//   // }

//   // List<int> _generateRandomChips() {
//   //   Random random = Random();
//   //   final List<int> myList =  List.generate(5, (index) => random.nextInt(1000)); // Generate random values between 0-100
//   //   debugPrint('_generateRandomChips: ${myList.length}');
//   //   for (var i = 0; i < myList.length; i++) {
//   //   }
//   //   return  myList;
//   // }

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
//             arrangeData(dataList!);
//             // initialChips= transformAndTruncateRange(valueDislay);
//             // nextChips= transformAndTruncateRange(valueDislay);

//             if (snapshot.data!.isEmpty ||
//                 snapshot.data == null ||
//                 snapshot.data == []) {
//                 return const Text('No Data Found');
//             }
//             // // List<int> members = dataList![0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
//             // List<dynamic> rawData = dataList![1]['data'];
//             // // final List<dynamic> memberTest = dataList[0]['member'].cast<int>();
//             // final List<int> inputNumberTest = rawData[0].cast<int>();
//             // final List<int> initialChipTest =transformAndTruncateRange(rawData[1]).cast<int>();
//             // final List<int> nextChipTest =transformAndTruncateRange(rawData[2]).cast<int>();
//             // final List<int> valueDisplayTest = transformAndRoundOriginal(rawData[2]);
//             // final List<int> valueDisplayPrevTest = transformAndRoundOriginal(rawData[2]);

//             final List<double> positionXCombined =syncDefautLists(positionXs,valueDislay);
//             final List<double> positionYCombined =syncDefautLists(positionYs,valueDislay);

//             // debugPrint('inputNumber: $inputNumber');
//             // debugPrint('initialChip: $sortedInitialChip - nextChip: $sortedNexChip');
//             // debugPrint('valuedisplay: $valueDislay  - valueDisplayPrev: $valueDisplayPrev');
//             // debugPrint('positionX: $positionXCombined - positionY: $positionYCombined');

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
//              valueDisplay:valueDislay,
//              valueDisplayPrev:valueDisplayPrev,
//              members:members,
//              positionXList:positionXCombined,
//              positionYList: positionYCombined,
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

//   debugPrint('inputNumber $inputNumber Sorted Keys:');
//   debugPrint('Members Sorted : $members');
//   debugPrint('initialChips Sorted Data[1]: $initialChips');
//   debugPrint('nextChips Sorted Data[2]: $nextChips');
//   debugPrint('valueDisplay & valueDisplayPRe: $nextChips');
// }
// }



