// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/functions.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chartScreen.dart';

// class ChartStreamPageRandom extends StatefulWidget {
//   const ChartStreamPageRandom({Key? key}) : super(key: key);

//   @override
//   State<ChartStreamPageRandom> createState() => _ChartStreamPageRandomState();
// }

// class _ChartStreamPageRandomState extends State<ChartStreamPageRandom> {
//   late Timer _timer;

//   // Default values
//   List<int> members = [1, 2, 3, 4, 5];
//   List<int> inputNumber = [1, 2, 3, 4, 5];

//   List<int> initialChips = [1,1,1,1,1];
//   List<int> nextChips = [1,1,1,1,1];
//   List<int> valueDisplayPrev = [1,1,1,1,1];
//   List<int> valueDislay = [1,1,1,1,1,];

//   List<double> positionX = [
//     525.2285714285714,
//     306.6657142857143,
//     347.32857142857137,
//     45.745714285714286,
//     -169.42857142857142
//   ];
//   List<double> positionY = [
//     287.7669902912621,
//     593.2427184466019,
//     788.0388349514562,
//     593.2427184466019,
//     287.7669902912621
//   ];

//   @override
//   void initState() {
//     debugPrint("ChartStreamPageRandom INIT");
//     super.initState();
//     _startUpdatingData();
//   }

//   void _startUpdatingData() {
//     debugPrint('Running _startUpdatingData every 5s');
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       setState(() {
//          nextChips = transformAndTruncateRange(_generateRandomChips()) ?? [0, 0, 0, 0, 0];
//          initialChips = transformAndTruncateRange(_generateRandomChips()) ?? [0, 0, 0, 0, 0];;
//         valueDislay = transformAndTruncateRange(_generateRandomChips());;
//         valueDisplayPrev = transformAndTruncateRange(_generateRandomChips());;

//         debugPrint('nextChips Length: ${nextChips.length}');
// debugPrint('initialChips Length: ${initialChips.length}');
// debugPrint('valueDislay Length: ${valueDislay.length}');
// debugPrint('valueDisplayPrev Length: ${valueDisplayPrev.length}');
//       });

//       Future.delayed(Duration(milliseconds: 100), () {
//         // Dispatch event to update Bloc state
//         context.read<ChartStreamBloc>().add(UpdateChartDataEvent(
//                     inputNumbers: inputNumber,
//                     initialChips: initialChips,
//                     nextChips: nextChips,
//                     valueDisplay:valueDislay,
//                     valueDisplayPrev:valueDisplayPrev,
//                     members:members,
//                     positionX:positionX,
//                     positionY:positionY,

//       ));
//       });
//     });
//   }

//   List<int> _generateRandomChips() {
//     Random random = Random();
//     return List.generate(
//         5, (index) => random.nextInt(500)); // Random values 0-1000
//   }

//   // void arrangeData(List<int> newData) {
//   //   debugPrint('Original Data: $newData');
//   //   newData.sort();

//   //   initialChips = _generateRandomChips();
//   //   nextChips = _generateRandomChips();

//   //   valueDisplayPrev = transformAndRoundOriginal(newData);
//   //   valueDislay = transformAndRoundOriginal(newData);

//   //   debugPrint('inputNumber: $inputNumber');
//   //   debugPrint('initialChips: $initialChips - nextChips: $nextChips');
//   //   debugPrint('valueDislay: $valueDislay - valueDisplayPrev: $valueDisplayPrev\n\n');
//   // }

//   @override
//   void dispose() {
//     _timer.cancel(); //Cancel timer when widget is removed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Builder(builder: (context) {
//   return ChartScreen(
//     inputNumbers: inputNumber,
//     initialChips: initialChips,
//     nextChips: nextChips,
//     members: members,
//     positionXList: positionX,
//     positionYList: positionY,
//     valueDisplay: valueDislay,
//     valueDisplayPrev: valueDisplayPrev,
//   );
// });

//       return
//       Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Value Display:',
//                   style: TextStyle(color: MyColor.white, fontSize: 18),
//                 ),
//                 ...valueDislay.map((e) => Text(
//                       '$e',
//                       style: const TextStyle(color: MyColor.white, fontSize: 18),
//                     )),

//                 const SizedBox(height: 10),

//                 const Text(
//                   'Value Display Prev:',
//                   style: TextStyle(color: MyColor.white, fontSize: 18),
//                 ),
//                 ...valueDisplayPrev.map((e) => Text(
//                       '$e',
//                       style: const TextStyle(color: MyColor.white, fontSize: 18),
//                     )),

//                 const SizedBox(height: 10),

//                 const Text(
//                   'Initial Chips:',
//                   style: TextStyle(color: MyColor.white, fontSize: 18),
//                 ),
//                 ...initialChips.map((e) => Text(
//                       '$e',
//                       style: const TextStyle(color: MyColor.white, fontSize: 18),
//                     )),

//                 const SizedBox(height: 10),

//                 const Text(
//                   'Next Chips:',
//                   style: TextStyle(color: MyColor.white, fontSize: 18),
//                 ),
//                 ...nextChips.map((e) => Text(
//                       '$e',
//                       style: const TextStyle(color: MyColor.white, fontSize: 18),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       );
//   }
// }
