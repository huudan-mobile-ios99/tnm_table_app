
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chart2DPage.dart';
// import 'package:tournament_client/utils/mystring.dart';

// class ChartScreenCopy extends StatefulWidget {
//   final List<Map<String, dynamic>> gameConfigs;
//   const ChartScreenCopy({Key? key, required this.gameConfigs}) : super(key: key);

//   @override
//   State<ChartScreenCopy> createState() => _ChartScreenCopyState();
// }

// class _ChartScreenCopyState extends State<ChartScreenCopy> {
//   late List<Chart2DPage> gameInstances;

//   @override
//   void initState() {
//     super.initState();
//     initializeGames();
//   }

//   void initializeGames() {
//     setState(() {
//       gameInstances = widget.gameConfigs
//           .map((config) => Chart2DPage(
//                 inputNumber: config["inputNumber"],
//                 initialChip: config["initialChip"],
//                 valueCredit: config["initialChip"],
//                 nextChip: config['nextChip'],
//                 positionX: config["positionX"],
//                 positionY: config["positionY"],
//               ))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final double positionX = width/12;
//     final double positionY = height-positionX-MyString.padding16;


//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Wrap(
//             spacing: MyString.padding16, // Small spacing to prevent wrapping too soon
//             runSpacing: MyString.padding16,
//             alignment: WrapAlignment.center,
//             children: List.generate(gameInstances.length, (index) {
//               return SizedBox(
//                 width: width / 6, // Ensures 5 columns,
//                 height:height,
//                 child: GameWidget(game: gameInstances[index]),
//               );
//             }),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
//             // FloatingActionButton(
//             //   onPressed: generateRandomGames,
//             //   child: Icon(Icons.refresh), // Random generation button
//             //   tooltip: "Generate Random Games",
//             // ),

//           ],
//         ),
//       ),
//     );
//   }
// }
