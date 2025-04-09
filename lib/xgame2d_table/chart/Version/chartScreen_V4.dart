// import 'package:collection/collection.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/widget/text.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_baccarat/chart/chart2DPage.dart';
// import 'package:tournament_client/utils/mystring.dart';

// class ChartScreenV4 extends StatefulWidget {
//   final List<int> inputNumbers;
//   final List<int> initialChips;
//   final List<int> nextChips;
//   final List<int> valueDisplay;
//   final List<int> members;
//   // final List<double> positionXList;
//   // final List<double> positionYList;
//   const ChartScreenV4({
//     Key? key,
//     required this.inputNumbers,
//     required this.initialChips,
//     required this.nextChips,
//     required this.valueDisplay,
//     required this.members,
//     // required this.positionXList,
//     // required this.positionYList,


//   }) : super(key: key);

//   @override
//   State<ChartScreenV4> createState() => _ChartScreenV4State();
// }

// class _ChartScreenV4State extends State<ChartScreenV4> {
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
//       // "positionX": widget.positionXList[index],
//       // "positionY": widget.positionYList[index],
//       "positionX": positionX,
//       "positionY": positionY,
//       "valueDisplay":widget.valueDisplay[index],
//       "members":widget.members[index],
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
//                 positionX: positionX,
//                 positionY: positionY,
//                 // positionX: config["positionX"],
//                 // positionY: config["positionY"],
//                 index: config['index'],
//                 played: config['played'],
//                 valueDisplay: config['valueDisplay'],
//                 members: config['members'],
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
//         body:  BlocListener<ChartStreamBloc, ChartStreamState>(
//         listener: (context, state) {
//           // Check if initialChips and nextChips have differences
//           if (state.initialChips.isNotEmpty &&
//               state.nextChips.isNotEmpty &&
//               !const ListEquality().equals(state.initialChips, state.nextChips)) {
//               applyChipAdjustments();
//           }
//         },
//         child:BlocBuilder<ChartStreamBloc, ChartStreamState>(builder: (context, state)  {
//           return Stack(
//             children: [
//               Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Wrap(
//                       spacing: MyString.padding16, // Small spacing to prevent wrapping too soon
//                       runSpacing: MyString.padding16,
//                       alignment: WrapAlignment.center,
//                       children:
//                       List.generate(gameInstances.length > 5 ? 5 : gameInstances.length, // Limit to 5 items
//                       // List.generate(gameInstances.length,
//                       (index) {
//                         return SizedBox(
//                           width: width / 6, // Ensures 5 columns,
//                           height: height,
//                           child: GameWidget(game: gameInstances[index]),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               ),

//             //Widget value from Bloc
//             Positioned(
//               top: 0,
//               right: MyString.padding08,
//               child: Container(
//                 decoration:BoxDecoration(
//                   color:MyColor.grey_tab,
//                   borderRadius: BorderRadius.circular(MyString.padding08)),
//                 padding:const EdgeInsets.all(MyString.padding08),
//                 child: textcustom(size:MyString.padding12, text:'${state.initialChips} - ${state.nextChips} - ${state.valueDisplay}',)))
//             ],
//           );

//         },)
//       ));
//   }
// }



