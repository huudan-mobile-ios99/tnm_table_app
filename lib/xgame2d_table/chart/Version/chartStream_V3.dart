// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/functions.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chartScreen.dart';
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/utils/mycolors.dart';

// class ChartStreamPageV3 extends StatefulWidget {
//   const ChartStreamPageV3({Key? key}) : super(key: key);
//   @override
//   State<ChartStreamPageV3> createState() => _ChartStreamPageV3State();
// }

// class _ChartStreamPageV3State extends State<ChartStreamPageV3> {
//   @override

//   late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
//   late final SocketManager mySocket = SocketManager();
//   late Stream<List<Map<String, dynamic>>> _creditStream;
//   final int durationthrottled = 1000;


//   // Define global variables
//   List<int> sortedMembers = [];
//   List<int> sortedInitialChip = [];
//   List<int> sortedNexChip= [];
//   List<int> inputNumber=[];
//   List<int> valueDisplay=[];
//   List<int> valueDisplayPrev=[];

//   //default value for testing
//   // List<int> sortedMembers = [11,20,33,44,55,];
//   // List<int> inputNumber=[1,2,3,4,5];
//   // List<int> sortedInitialChip = [0,0,0,0,0];
//   // late List<int> sortedNexChip;
//   // List<int> valueDisplayPrev=[999,2000,2500,249,4999];
//   // List<int> valueDislay=[999,2000,2500,249,4999];



//   @override
//   void initState() {
//     super.initState();
//     mySocket.initSocket();
//     _creditStream = mySocket.dataStream;

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
//       widthItem*1.5, //#1
//       widthItem*0.905,
//       widthItem*1.025,
//       widthItem*0.135,
//       -widthItem/2,
//       ];//HORIZONTAL
//     final List<double> positionYs = [
//       heightItem*1.5,
//       heightItem*3.2,
//       heightItem*4.35,
//       heightItem*3.2,
//       heightItem*1.5
//       ]; //VERTICAL

//     return StreamBuilder<List<Map<String, dynamic>>>(
//         stream: mySocket.dataStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final List<Map<String, dynamic>>? dataList = snapshot.data;
//             // arrangeData(dataList!);
//             // sortedNexChip= transformAndTruncateRange(valueDislay);

//             if (snapshot.data!.isEmpty ||
//                 snapshot.data == null ||
//                 snapshot.data == []) {
//                 return const Text('No Data Found');
//             }

//             // List<dynamic> rawData = dataList![1]['data'];
//             // List<int> members = dataList![0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
//             // final List<int> inputNumber = rawData[0].cast<int>();
//             // final List<int> initialChip =transformAndTruncateRange(rawData[1]).cast<int>();
//             // final List<int> nextChip =transformAndTruncateRange(rawData[2]).cast<int>();
//             // final List<int> valueDisplay = transformAndRoundOriginal(rawData[2]);
//             // final List<int> valueDisplayPrev = transformAndRoundOriginal(rawData[2]);
//             final List<double> positionXCombined =syncDefautLists(positionXs,valueDisplay);
//             final List<double> positionYCombined =syncDefautLists(positionYs,valueDisplay);

//             // debugPrint('members: $members - inputNumber: $inputNumber');
//             // debugPrint('initialChip: $initialChip - nextChip: $nextChip');
//             // debugPrint('valuedisplay: $valueDisplay  - valueDisplayPrev: $valueDisplayPrev');
//             // debugPrint('positionX: $positionXCombined - positionY: $positionYCombined');

//             // Dispatch event to update Bloc state
//             context.read<ChartStreamBloc>().add(UpdateChartDataEvent(
//                     inputNumbers: inputNumber,
//                     initialChips: initialChip,
//                     nextChips: nextChip,
//                     valueDisplay:valueDisplay,
//                     valueDisplayPrev:valueDisplayPrev,
//                     members:members,
//                     positionX:positionXs,
//                     positionY:positionYs,
//             ));

//            return SizedBox(
//             width:width,height:height,
//              child:
//              ChartScreen(
//               inputNumbers: inputNumber,
//               initialChips: initialChip,
//               nextChips: nextChip,
//               valueDisplay:valueDisplay,
//               valueDisplayPrev:valueDisplayPrev,
//               members:members,
//                positionXList:positionXCombined,
//                positionYList: positionYCombined,
//              ),

//            );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator( strokeWidth: 1, color: MyColor.white),
//             );
//           }
//         },
//     );
//   }



// // void arrangeData(List<Map<String, dynamic>> dataList) {
// //   List<int> members = dataList[0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
// //   List<dynamic> rawData = dataList[1]['data'];

// //   debugPrint('Original Members: $members');
// //   debugPrint('Original RawData: $rawData');

// //   // Extract the first list (keys) from rawData
// //   List<int> keys = List<int>.from(rawData[0]);

// //   // Create a list of tuples (key, member, data1, data2) for sorting
// //   List<Map<String, dynamic>> combined = List.generate(keys.length, (index) {
// //     return {
// //       'key': keys[index],
// //       'member': members[index],
// //       'data1': (rawData[1][index] as num).round().toInt(), // Ensure int conversion
// //       'data2': (rawData[2][index] as num).round().toInt(), // Ensure int conversion
// //     };
// //   });

// //   // Sort by key in ascending order
// //   combined.sort((a, b) => a['key'].compareTo(b['key']));

// //   // Extract sorted values
// //   inputNumber = combined.map((e) => e['key'] as int).toList();
// //   sortedMembers = combined.map((e) => e['member'] as int).toList();
// //   sortedInitialChip =transformAndTruncate( combined.map((e) => e['data1'] as int).toList());
// //   sortedNexChip =transformAndTruncate( combined.map((e) => e['data2'] as int).toList());
// //   valueDislay = transformAndRoundOriginal(combined.map((e) => (e['data2'] as int).toInt()).toList());
// //   valueDisplayPrev = transformAndRoundOriginal(combined.map((e) => (e['data1'] as int).toInt()).toList());

// //   // Update rawData
// //   rawData[0] = inputNumber;
// //   rawData[1] = sortedInitialChip;
// //   rawData[2] = sortedNexChip;

// //   debugPrint('Sorted Keys: $inputNumber');
// //   debugPrint('Sorted Members: $sortedMembers');
// //   debugPrint('Sorted Data[1]: $sortedInitialChip');
// //   debugPrint('Sorted Data[2]: $sortedNexChip');
// // }
// }



