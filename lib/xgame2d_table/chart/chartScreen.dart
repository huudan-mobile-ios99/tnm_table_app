import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/service/format.factory.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/chart/chart2DPage.dart';

class ChartScreen extends StatefulWidget {
  final List<int> inputNumbers;
  final List<int> initialChips;
  final List<int> nextChips;
  final List<int> members;
  final List<double> positionXList;
  final List<double> positionYList;
  final List<int> valueDisplay;
  final List<int> valueDisplayPrev;
  const ChartScreen({
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
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late List<Chart2DPage> gameInstances = [];
  @override
  void initState() {
    super.initState();
    // Delay initialization until the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateGames();
    });

  }

  void generateGames() {
  List<Map<String, dynamic>> gameConfigs = List.generate(widget.inputNumbers.length, (index) {
    return {
      "inputNumber": widget.inputNumbers[index],
      "initialChip": widget.initialChips[index],
      "nextChip": widget.nextChips[index],
      "positionX": widget.positionXList[index],
      "positionY": widget.positionYList[index],
      "valueDisplay":widget.valueDisplay[index],
      "valueDisplayPrev":widget.valueDisplayPrev[index],
      "members":widget.members[index],
      "index": index,
      "played": false, // Default value
    };
   });
     gameInstances = gameConfigs.map((config) => Chart2DPage(
      inputNumber: config["inputNumber"],
      initialChip: config["initialChip"],
      nextChip: config["nextChip"],
      positionX: config["positionX"],
      positionY: config["positionY"],
      index: config['index'],
      played: config['played'],
      valueDisplay: config['valueDisplay'],
      valueDisplayPrev: config['valueDisplayPrev'],
      members: config['members'],
    )).toList();
  }





Future<void> applyChipAdjustments () async{
  setState(() {

  });
    for (int i = 0; i < gameInstances.length; i++) {
    int diff = widget.nextChips[i] - widget.initialChips[i];
    debugPrint('applyChipAdjustments #$i: $diff');
    if (diff > 0) {
      debugPrint('DIFF[i]=$i > 0 LISTENER');
      gameInstances[i].increaseChipsBy(diff); // Increase chips directly
      gameInstances[i].updateInputNumberText(formatNumberNoZero(widget.valueDisplay[i].toDouble()));
      gameInstances[i].updateChipCountText();//Update chips count text
      gameInstances[i].updateInputNumberPosition();//Update text position

    } else if (diff < 0) {
      debugPrint('DIFF[i]=$i < 0 LISTENER');
      gameInstances[i].decreaseChipsBy(-diff); // Decrease chips directly
      gameInstances[i].updateInputNumberText(formatNumberNoZero(widget.valueDisplay[i].toDouble()));
      gameInstances[i].updateChipCountText();//Update chips count text
      gameInstances[i].updateInputNumberPosition();//Update text position
    }else if(diff==0){
      gameInstances[i].updateInputNumberText(formatNumberNoZero(widget.valueDisplay[i].toDouble()));
      gameInstances[i].updateChipCountText();//Update chips count text
      gameInstances[i].updateInputNumberPosition();//Update text position
    }

    if(widget.valueDisplay[i]==0 && widget.nextChips[i]==0){
      gameInstances[i].updateInputNumberText('0');
      gameInstances[i].updateInputNumberPosition();//Update text position


    }else if(widget.valueDisplay[i]!=0 && widget.nextChips[i]==0){
      gameInstances[i].updateInputNumberText(formatNumberNoZero(widget.valueDisplay[i].toDouble()));
      gameInstances[i].updateInputNumberPosition();//Update text position
    }
  }



}



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocListener<ChartStreamBloc, ChartStreamState>(
        listener: (context, stateListener) {
          debugPrint("New state received: valueDisplay=${stateListener.valueDisplay},nextChips=${stateListener.nextChips}");
          // setState(() {
          //   for (var index = 0; index < gameInstances.length; index++) {
          //     gameInstances.add(Chart2DPage(
          //     inputNumber: stateListener.inputNumbers[index],
          //     initialChip: stateListener.initialChips[index],
          //     nextChip: stateListener.nextChips[index],
          //     positionX: widget.positionXList[index],
          //     positionY: widget.positionYList[index],
          //     index: index,
          //     played: false,
          //     valueDisplay: stateListener.valueDisplay[index],
          //     valueDisplayPrev: stateListener.valueDisplayPrev[index],
          //     members: widget.members[index],
          //     ));
          // }
          // });
          applyChipAdjustments();
        },
        child: BlocBuilder<ChartStreamBloc, ChartStreamState>(builder:(context, state) {
          return  Stack(
            children: [
              Wrap(
                spacing: 0, // Small spacing to prevent wrapping too soon
                runSpacing: 0,
                alignment: WrapAlignment.center,
                children:
                List.generate(gameInstances.length > 5 ? 5 : gameInstances.length, // Limit to 5 items
                (index) {
                int reversedIndex = (gameInstances.length > 5 ? 5 : gameInstances.length) - 1 - index; // Reverse index

                if (state.valueDisplay[reversedIndex] == 0  ) {
                  debugPrint("Rebuilding GameWidget at index $reversedIndex due to valueDisplay == 0");
                  return SizedBox(
                    width: width / 5,
                    height: height,
                    child: GameWidget(
                      game: Chart2DPage(
                      inputNumber: widget.inputNumbers[reversedIndex], // Reset input
                      initialChip: 0, // Reset chips
                      nextChip: 0,
                      positionX: widget.positionXList[reversedIndex],
                      positionY: widget.positionYList[reversedIndex],
                      index: index,
                      played: false,
                      valueDisplay: 0,
                      valueDisplayPrev: 0,
                      members: widget.members[reversedIndex],
                    )),
                  );
                }
                if (state.valueDisplay[reversedIndex] != 0 && state.nextChips[reversedIndex]==0) {
                  debugPrint("Rebuilding GameWidget at index $reversedIndex due to valueDisplay != 0");
                  return SizedBox(
                    width: width / 5,
                    height: height,
                    child: GameWidget(
                      game: Chart2DPage(
                      inputNumber: widget.inputNumbers[reversedIndex], // Reset input
                      initialChip: 0, // Reset chips
                      nextChip: 0,
                      positionX: widget.positionXList[reversedIndex],
                      positionY: widget.positionYList[reversedIndex],
                      index: index,
                      played: false,
                      valueDisplay: state.valueDisplay[reversedIndex],
                      valueDisplayPrev: state.valueDisplayPrev[reversedIndex],
                      members: widget.members[reversedIndex],
                    )),
                  );
                }
                  return SizedBox(
                   width: width / 5, // Ensures 5 columns,
                   height: height,
                   child:
                   Builder(
                     builder: (context) {
                       return GameWidget(
                         key: ValueKey(gameInstances[reversedIndex]), // Forces rebuild when data changes
                         game: gameInstances[reversedIndex]
                       );
                     }
                   ),
                   // GameWidget(
                   //   game: gameInstances[reversedIndex]
                   // ),
                  //  GameWidget(
                  //  game: Chart2DPage(
                  //    inputNumber: widget.inputNumbers[reversedIndex], // Reset input
                  //    initialChip: gameInstances[reversedIndex].initialChip, // Reset chips
                  //    nextChip: gameInstances[reversedIndex].nextChip,
                  //    positionX: widget.positionXList[reversedIndex],
                  //    positionY: widget.positionYList[reversedIndex],
                  //    index: index,
                  //    played: false,
                  //    valueDisplay: widget.valueDisplay[reversedIndex],
                  //    valueDisplayPrev: widget.valueDisplayPrev[reversedIndex],
                  //    members: widget.members[reversedIndex],
                  //  ))
                  );

                }),
              ),
            // Widget value from Bloc
            Positioned(
              bottom:0,
              left: 150.0,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: width/3,
                  // height:25.0,
                  decoration:BoxDecoration(
                    color:MyColor.black_absolute,
                    borderRadius: BorderRadius.circular(MyString.padding02)),
                  padding:const EdgeInsets.all(MyString.padding04),
                  child: textcustomColor(color:MyColor.white, size:MyString.padding12, text:'${state.initialChips}-N:${state.nextChips}-VPrev:${state.valueDisplayPrev}-V:${state.valueDisplay} ' )),
             ))
          ],
          );
         },)

      );
  }
}






















// void applyChipAdjustments() {
//   if (!mounted) return;
//   for (int i = 0; i < gameInstances.length; i++) {
//     int diff = widget.nextChips[i] - widget.initialChips[i];

//     if (diff > 0) {
//       gameInstances[i].increaseChipsBy(diff);
//     } else if (diff < 0) {
//       gameInstances[i].decreaseChipsBy(-diff);
//     }
//     gameInstances[i].updateInputNumberText(widget.valueDisplay[i].toString());
//     gameInstances[i].updateChipCountText();
//     gameInstances[i].updateInputNumberPosition();

//     if (widget.valueDisplay[i] == 0 && widget.nextChips[i] == 0) {
//       gameInstances[i].updateInputNumberText('\$0');
//     }
//   }
//   setState(() {});  // Ensures UI rebuilds with updated values
// }
