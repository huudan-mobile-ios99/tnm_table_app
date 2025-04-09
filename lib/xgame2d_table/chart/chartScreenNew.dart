import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
class ChartScreenNew extends StatelessWidget {
  final List<int> inputNumbers;
  final List<int> initialChips;
  final List<int> nextChips;
  final List<int> members;
  final List<double> positionXList;
  final List<double> positionYList;
  final List<int> valueDisplay;
  final List<int> valueDisplayPrev;

  const ChartScreenNew({
    Key? key,
    required this.inputNumbers,
    required this.initialChips,
    required this.nextChips,
    required this.members,
    required this.positionXList,
    required this.positionYList,
    required this.valueDisplay,
    required this.valueDisplayPrev,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<ChartStreamBloc, ChartStreamState>(
    buildWhen: (previous, current) {
    return !(listEquals(previous.valueDisplay, current.valueDisplay) &&
        listEquals(previous.inputNumbers, current.inputNumbers) &&
        listEquals(previous.initialChips, current.initialChips) &&
        listEquals(previous.nextChips, current.nextChips) &&
        listEquals(previous.valueDisplayPrev, current.valueDisplayPrev));
    },

      builder: (context, state) {
      return Stack(
      children: [
      SizedBox(
      height: height, // Ensure it has a height
      width: width, // Ensure it has a width
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: inputNumbers.length > 5 ? 5 : inputNumbers.length,
        itemBuilder: (context, index) {
          int reversedIndex = (inputNumbers.length > 5 ? 5 : inputNumbers.length) - 1 - index;
          debugPrint("Building GameWidget index $reversedIndex"); // Log when GameWidget is rebuilt
          return SizedBox(
            width: width / 5,
            height: height,
            child:
            // GameWidget(
            //   key: ValueKey('${inputNumbers[reversedIndex]}-${valueDisplay[reversedIndex]}'),
            //   game: Chart2DPageNew(
            //     index: reversedIndex,
            //     inputNumber: inputNumbers[reversedIndex],
            //     initialChip: initialChips[reversedIndex],
            //     nextChip: nextChips[reversedIndex],
            //     positionX: positionXList[reversedIndex],
            //     positionY: positionYList[reversedIndex],
            //     valueDisplay: valueDisplay[reversedIndex],
            //     valueDisplayPrev: valueDisplayPrev[reversedIndex],
            //     members: members[reversedIndex],
            //     played: false,
            //   ),
            // ),
            GameWidget(
            key: ValueKey(state.gameInstances[reversedIndex].index),
            game: state.gameInstances[reversedIndex],
             ),
          );
        },
      ),
    )
    ],
    );
  });

  }
}








// class GameListWidget extends StatelessWidget {
//   final List<int> inputNumbers;
//   final List<int> initialChips;
//   final List<int> nextChips;
//   final List<int> members;
//   final List<double> positionXList;
//   final List<double> positionYList;
//   final List<int> valueDisplay;
//   final List<int> valueDisplayPrev;
//   final double width;
//   final double height;

//   const GameListWidget({
//     Key? key,
//     required this.inputNumbers,
//     required this.initialChips,
//     required this.nextChips,
//     required this.members,
//     required this.positionXList,
//     required this.positionYList,
//     required this.valueDisplay,
//     required this.valueDisplayPrev,
//     required this.width,
//     required this.height,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("Building GameListWidget"); // Log when GameListWidget is rebuilt

//     return SizedBox(
//       height: height, // Ensure it has a height
//       width: width, // Ensure it has a width
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: inputNumbers.length > 5 ? 5 : inputNumbers.length,
//         itemBuilder: (context, index) {
//           int reversedIndex = (inputNumbers.length > 5 ? 5 : inputNumbers.length) - 1 - index;
//           debugPrint("Building GameWidget index $reversedIndex"); // Log when GameWidget is rebuilt

//           return SizedBox(
//             width: width / 5,
//             height: height,
//             child: GameWidget(
//               key: ValueKey('${inputNumbers[reversedIndex]}-${valueDisplay[reversedIndex]}'),
//               game: Chart2DPageNew(
//                 index: reversedIndex,
//                 inputNumber: inputNumbers[reversedIndex],
//                 initialChip: initialChips[reversedIndex],
//                 nextChip: nextChips[reversedIndex],
//                 positionX: positionXList[reversedIndex],
//                 positionY: positionYList[reversedIndex],
//                 valueDisplay: valueDisplay[reversedIndex],
//                 valueDisplayPrev: valueDisplayPrev[reversedIndex],
//                 members: members[reversedIndex],
//                 played: false,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
