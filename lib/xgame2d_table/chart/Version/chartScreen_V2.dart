// import 'dart:math';
// import 'package:flame/game.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chart2DPage.dart';
// import 'package:tournament_client/utils/mystring.dart';

// class ChartScreenCopy2 extends StatefulWidget {
//   final List<int> inputNumber;
//   final List<int> initialChip;
//   final List<int> nextChip;
//   final List<int> valueCredit;

//   ChartScreenCopy2({
//     Key? key,
//     required this.inputNumber,
//     required this.initialChip,
//     required this.nextChip,
//     required this.valueCredit,
//   }) : super(key: key);

//   @override
//   State<ChartScreenCopy2> createState() => _ChartScreenCopy2State();
// }

// class _ChartScreenCopy2State extends State<ChartScreenCopy2> {
//   late ValueNotifier<List<Chart2DPage>> gameInstancesNotifier;

//   @override
//   void initState() {
//     super.initState();
//     gameInstancesNotifier = ValueNotifier([]);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       generateGames();
//     });
//   }

//   @override
//   void didUpdateWidget(covariant ChartScreenCopy2 oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (!listEquals(widget.inputNumber, oldWidget.inputNumber) ||
//         !listEquals(widget.initialChip, oldWidget.initialChip) ||
//         !listEquals(widget.nextChip, oldWidget.nextChip) ||
//         !listEquals(widget.valueCredit, oldWidget.valueCredit)) {
//       generateGames(); // Rebuild instances when data updates
//     }
//   }

//   void generateGames() {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final double positionX = width / 12;
//     final double positionY = height - positionX - MyString.padding16;

//     gameInstancesNotifier.value = List.generate(widget.inputNumber.length, (index) {
//       return Chart2DPage(
//         inputNumber: widget.inputNumber[index],
//         initialChip: widget.initialChip[index],
//         nextChip: widget.nextChip[index],
//         // valueCredit: widget.valueCredit[index],
//         positionX: positionX,
//         positionY: positionY,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Center(
//         child: ValueListenableBuilder<List<Chart2DPage>>(
//           valueListenable: gameInstancesNotifier,
//           builder: (context, gameInstances, _) {
//             return Wrap(
//               spacing: 0,
//               runSpacing: 0,
//               alignment: WrapAlignment.center,
//               children: List.generate(gameInstances.length, (index) {
//                 return SizedBox(
//                   width: width / 6, // Ensures 5 columns
//                   height: height,
//                   child: GameWidget(
//                     loadingBuilder: (p0) {
//                       return const Text('Loading Game...');
//                     },
//                     game: gameInstances[index],
//                   ),
//                 );
//               }),
//             );
//           },
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           FloatingActionButton(
//             onPressed: () {
//               for (var game in gameInstancesNotifier.value) {
//                 game.increaseChips();
//               }
//               gameInstancesNotifier.notifyListeners(); // 🔥 Notify listeners
//             },
//             child: const Icon(Icons.add),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               for (var game in gameInstancesNotifier.value) {
//                 game.decreaseChips();
//               }
//               gameInstancesNotifier.notifyListeners(); // 🔥 Notify listeners
//             },
//             child: const Icon(Icons.remove),
//           ),
//           FloatingActionButton(
//             onPressed: generateGames,
//             tooltip: "Generate Random Games",
//             child: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     gameInstancesNotifier.dispose();
//     super.dispose();
//   }
// }
