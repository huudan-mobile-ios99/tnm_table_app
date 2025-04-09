
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chart2DPage.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/getx/chartController.dart';

// class ChartScreenV3 extends StatefulWidget {
//   final List<int> inputNumbers;
//   final List<int> initialChips;
//   final List<int> nextChips;
//   const ChartScreenV3({
//     Key? key,
//     required this.inputNumbers,
//     required this.initialChips,
//     required this.nextChips,
//   }) : super(key: key);

//   @override
//   State<ChartScreenV3> createState() => _ChartScreenStateV3();
// }

// class _ChartScreenStateV3 extends State<ChartScreenV3> {
//   late List<Chart2DPage> gameInstances = [];

//   @override
//   void initState() {
//     // Delay initialization until the first frame is rendered
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       generateRandomGames();
//     });
//     super.initState();
//   }

//   void generateRandomGames() {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final double positionX = width / 12;
//     final double positionY = height - positionX - 36;



//     List<Map<String, dynamic>> gameConfigs = List.generate(widget.inputNumbers.length, (index) {
//     return {
//       "inputNumber": widget.inputNumbers[index],
//       "initialChip": widget.initialChips[index],
//       "nextChip": widget.nextChips[index],
//       "positionX": positionX,
//       "positionY": positionY,
//       "index": index,
//       "played": false, // Default value
//     };
//   });
//     setState(() {
//       gameInstances = gameConfigs
//           .map((config) => Chart2DPage(
//                 inputNumber: config["inputNumber"],
//                 initialChip: config["initialChip"],
//                 nextChip: config["nextChip"],
//                 positionX: config["positionX"],
//                 positionY: config["positionY"],
//                 index: config['index'],
//                 played: config['played'],
//               ))
//           .toList();
//     });
//   }




// void applyChipAdjustments() {
//   for (int i = 0; i < gameInstances.length; i++) {
//     int diff = widget.nextChips[i] - widget.initialChips[i];

//     if (diff > 0) {
//       gameInstances[i].increaseChipsBy(diff); // Increase chips directly
//     } else if (diff < 0) {
//       gameInstances[i].decreaseChipsBy(-diff); // Decrease chips directly
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final double positionX = width / 12;
//     final double positionY = height - positionX - MyString.padding16;

//     return Scaffold(
//        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 for (var game in gameInstances) {
//                   game.increaseChips(); // Increase chips for all games
//                 }
//               },
//               child: const Icon(Icons.add),
//             ),
//             FloatingActionButton(
//               onPressed: () {
//                 for (var game in gameInstances) {
//                   game.decreaseChips(); // Decrease chips for all games
//                 }
//               },
//               child: const Icon(Icons.remove),
//             ),
//             FloatingActionButton(
//               onPressed: applyChipAdjustments,
//               tooltip: "Run",
//               child: const Icon(Icons.play_arrow),
//             ),
//           ],
//         ),
//         body: GetBuilder<ChartStreamController>(builder: (controller) {
//           debugPrint('controller : ${controller.initialChips.value.toString()} - ${controller.nextChips.value.toString()} ');
//           return Stack(
//             children: [
//               Center(
//               child: Wrap(
//                 spacing: MyString.padding16, // Small spacing to prevent wrapping too soon
//                 runSpacing: MyString.padding16,
//                 alignment: WrapAlignment.center,
//                 children: List.generate(gameInstances.length, (index) {
//                   return SizedBox(
//                     width: width / 6, // Ensures 5 columns,
//                     height: height,
//                     child: GameWidget(game: gameInstances[index]),
//                   );
//                 }),
//               ),
//               ),

//             //Widget Stream GetX
//             Positioned(
//               bottom: MyString.padding16,
//               left: MyString.padding16,
//               child: Container(
//                 color:MyColor.grey_tab,
//                 padding: const EdgeInsets.all(MyString.padding16),
//                 child: Text('controller : ${controller.initialChips.value.toString()} - ${controller.nextChips.value.toString()} ',style: const TextStyle(color: MyColor.black_absolute),)))

//             ],
//           );

//         },)
//       );
//   }
// }
