import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame2d_table/chart/getx/chartController.dart';
class ChartScreenNew2 extends StatelessWidget {
  // final List<int> inputNumbers;
  // final List<int> initialChips;
  // final List<int> nextChips;
  // final List<int> members;
  // final List<double> positionXList;
  // final List<double> positionYList;
  // final List<int> valueDisplay;
  // final List<int> valueDisplayPrev;

  const ChartScreenNew2({
    Key? key,
    // required this.inputNumbers,
    // required this.initialChips,
    // required this.nextChips,
    // required this.members,
    // required this.positionXList,
    // required this.positionYList,
    // required this.valueDisplay,
    // required this.valueDisplayPrev,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ChartStreamController chartController = Get.put(ChartStreamController());

      return GetBuilder<ChartStreamController>(builder: (chartController)=>ListView.builder(
        itemCount: chartController.inputNumbers.length,
        itemBuilder:(context, index) {
      int maxItems = chartController.gameInstances.length < 5
      ? chartController.gameInstances.length
      : 5;
      return Stack(
      children: [
      SizedBox(
      height: height, // Ensure it has a height
      width: width, // Ensure it has a width
      child: ListView.builder(
      itemCount: maxItems,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
      int reversedIndex = maxItems - 1 - index;
      if (reversedIndex < 0 || reversedIndex >= chartController.gameInstances.length) {
        return const SizedBox(); // Avoids out-of-bounds errors
      }
      debugPrint("Building GameWidget index $reversedIndex");
      return SizedBox(
        width: width / 5,
        height: height,
        child: GameWidget(
          key: ValueKey(chartController.gameInstances[reversedIndex].index),
          game: chartController.gameInstances[reversedIndex],
        ),
      );
    },)
    ),

    //Positioned:
    // Positioned(
    //           bottom:0,
    //           left: 150.0,
    //           child: Center(
    //             child: Container(
    //               alignment: Alignment.center,
    //               width: width/3,
    //               // height:25.0,
    //               decoration:BoxDecoration(
    //                 color:MyColor.black_absolute,
    //                 borderRadius: BorderRadius.circular(MyString.padding02)),
    //               padding:const EdgeInsets.all(MyString.padding04),
    //               child: textcustomColor(color:MyColor.white, size:MyString.padding12, text:'member:${chartController.members} | ${chartController.initialChips}-N:${chartController.nextChips}-VPrev:${chartController.valueDisplayPrev}-V:${chartController.valueDisplay} ' )),
    //          ))

    ],
    );
    },));
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
