import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/chart/chart2DPage.dart';

class ChartScreenV5 extends StatefulWidget {
  final List<int> inputNumbers;
  final List<int> initialChips;
  final List<int> nextChips;

  final List<int> members;
  final List<double> positionXList;
  final List<double> positionYList;

  final List<int> valueDisplay;
  final List<int> valueDisplayPrev;
  const ChartScreenV5({
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
  State<ChartScreenV5> createState() => _ChartScreenV5State();
}

class _ChartScreenV5State extends State<ChartScreenV5> {
  late List<Chart2DPage> gameInstances = [];

  @override
  void initState() {
    // Delay initialization until the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateGames();
    });
    super.initState();
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
    setState(() {
      gameInstances = gameConfigs
          .map((config) => Chart2DPage(
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
              ),
              )
          .toList();
    });
  }




void applyChipAdjustments({required List<int> valueDisplay,required List<int>  valueDisplayPrev}) {
  for (int i = 0; i < gameInstances.length; i++) {
    int diff = widget.nextChips[i] - widget.initialChips[i];


    if (diff > 0) {
      debugPrint('DIFF > 0 LISTENER');
      gameInstances[i].increaseChipsBy(diff); // Increase chips directly
      gameInstances[i].addInputNumberText(widget.valueDisplay[i].toString());
      gameInstances[i].updateChipCountText();//Update chips count text
      gameInstances[i].updateInputNumberPosition();//Update text position

    } else if (diff < 0) {
      debugPrint('DIFF < 0 LISTENER');
      gameInstances[i].decreaseChipsBy(-diff); // Decrease chips directly
      gameInstances[i].addInputNumberText(widget.valueDisplay[i].toString());
      gameInstances[i].updateChipCountText();
      gameInstances[i].updateInputNumberPosition(); //Update text position
    }
    else if(diff==0){
      gameInstances[i].addInputNumberText(widget.valueDisplay[i].toString());
      gameInstances[i].updateChipCountText();
    }
  }
  // for (int j = 0; j < valueDisplay.length; j++) {
  //   debugPrint('UPDATE TEXT');
  //   if(valueDisplay[j]!=valueDisplayPrev[j]){
  //     gameInstances[j].addInputNumberText(widget.valueDisplay[j].toString());
  //   }

  // }
}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocListener<ChartStreamBloc, ChartStreamState>(
        listener: (context, stateListener) {
          // Check if initialChips and nextChips have differences
          if (stateListener.initialChips.isNotEmpty &&
              stateListener.nextChips.isNotEmpty &&
              !const ListEquality().equals(stateListener.initialChips, stateListener.nextChips
             ))
          {
              applyChipAdjustments(valueDisplay: stateListener.valueDisplay,valueDisplayPrev:  stateListener.valueDisplayPrev);
          }
          if(stateListener.valueDisplayPrev!= stateListener.valueDisplay){
              debugPrint('NEED TO REBUILD GAME TEXTINPUT');
          }


        },
        child:BlocBuilder<ChartStreamBloc, ChartStreamState>(builder: (context, state)  {
          return Stack(
            children: [
              Wrap(
                spacing: 0, // Small spacing to prevent wrapping too soon
                runSpacing: 0,
                alignment: WrapAlignment.center,
                children:
                List.generate(gameInstances.length > 5 ? 5 : gameInstances.length, // Limit to 5 items
                // List.generate(gameInstances.length,
                (index) {
                  return SizedBox(
                    // color:MyColor.grey_tab_opa,
                    width: width / 5, // Ensures 5 columns,
                    height: height,
                    child: GameWidget(
                      game: gameInstances[index]),
                  );

                }),
              ),
            //Widget value from Bloc
            // Positioned(
            //   bottom:0,
            //   right: MyString.padding16,
            //   child: Container(
            //     decoration:BoxDecoration(
            //       color:MyColor.grey_tab,
            //       borderRadius: BorderRadius.circular(MyString.padding08)),
            //     padding:const EdgeInsets.all(MyString.padding08),
            //     child: textcustom(size:MyString.padding12, text:'${state.initialChips} - ${state.nextChips} -Display ${state.valueDisplay} - Display Prev ${state.valueDisplayPrev}',)))

         ],
          );

        },)
      );
  }
}



