// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chartScreen.dart';
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xpage/home/home.dart';

// class ChartStreamPageCopy extends StatefulWidget {
//   const ChartStreamPageCopy({Key? key}) : super(key: key);

//   @override
//   State<ChartStreamPageCopy> createState() => _ChartStreamPageCopyState();
// }

// class _ChartStreamPageCopyState extends State<ChartStreamPageCopy> {
//   @override

//   late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
//   late final SocketManager mySocket = SocketManager();
//   late Stream<List<Map<String, dynamic>>> _creditStream;

//   final int durationthrottled = 1000;

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
//     final double positionX = width/12;
//     final double positionY = height-positionX-36;
//     List<int> reduceValuesBy25Percent(List<int> numbers) {
//       return numbers.map((num) => (num * 0.75).toInt()).toList();
//     }
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Padding(
//         padding: const EdgeInsets.only(top:kIsWeb? MyString.TOP_PADDING_TOPRAKINGREALTIME : 0.0),
//         child: SafeArea(
//           child: StreamBuilder<List<Map<String, dynamic>>>(
//             stream: mySocket.dataStream,
//             // stream: _throttledStream,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {

//                 if (snapshot.data!.isEmpty ||
//                     snapshot.data == null ||
//                     snapshot.data == []) {
//                     return const Text('No Data Found');
//                 }
//                 final List<Map<String, dynamic>>? dataList = snapshot.data;
//                 final List<String> member = List<String>.from(dataList![0]['member']);
//                 final List<dynamic> rawData = dataList![1]['data'];
//                 // Ensure rawData items are correctly converted to List<int>
//                 List<int> transformAndRound(List<dynamic> points) {
//                   return points.map((e) => (e is num) ? (e / 10).round() : 0).toList();
//                 }
//                 // Explicitly convert List<dynamic> to List<int>
//                 final List<int> inputNumber = List<int>.from(rawData[0]);
//                 final List<int> initialChip = transformAndRound(List<num>.from(rawData[1]));
//                 final List<int> nextChip = transformAndRound(List<num>.from(rawData[2]));
//                 final List<int> valueCredit = List<int>.from(rawData[2]);

//                 debugPrint('inputNumber: $inputNumber');
//                 debugPrint('initialChip: $initialChip');
//                 debugPrint('nextChip: $nextChip');

//               // return  ChartScreen(
//               //   inputNumber : initialChip,
//               //   // inputNumber : inputNumber,
//               //   initialChip : initialChip,
//               //   nextChip : nextChip,
//               //   valueCredit : nextChip,
//               // );
//               // return ChartScreen();
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator( strokeWidth: 1, color: MyColor.white),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
