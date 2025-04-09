import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_client/xgame2d_table/view/chart2DPageNew.dart';

class ChartStreamController extends GetxController {
  RxList<int> inputNumbers = <int>[].obs;
  RxList<int> initialChips = <int>[].obs;
  RxList<int> nextChips = <int>[].obs;
  RxList<int> valueDisplay = <int>[].obs;
  RxList<int> valueDisplayPrev = <int>[].obs;
  RxList<int> members = <int>[].obs;
  RxList<double> positionX = <double>[].obs;
  RxList<double> positionY = <double>[].obs;
  var gameInstances = <Chart2DPageNew>[].obs;

  @override
  void onInit() {
    super.onInit();
    members.assignAll(List.filled(5, 0)); // Ensure `members` has at least 5 elements
    loadGames();
    debugPrint("Game instances initialized: ${gameInstances.length}");
  }

 void loadGames() {
    gameInstances.addAll([
      Chart2DPageNew(
        index: 0,
        inputNumber: 0,
        initialChip: 0,
        nextChip: 0,
        positionX: 0,
        positionY: 0,
        members: 0,
        valueDisplay: 0,
        valueDisplayPrev: 0,
      ),
      Chart2DPageNew(
        index: 1,
        inputNumber: 0,
        initialChip: 0,
        nextChip: 0,
        positionX: 0,
        positionY: 0,
        members: 0,
        valueDisplay: 0,
        valueDisplayPrev: 0,
      ),
      Chart2DPageNew(
        index: 2,
        inputNumber: 0,
        initialChip: 0,
        nextChip: 0,
        positionX: 0,
        positionY: 0,
        members: 0,
        valueDisplay: 0,
        valueDisplayPrev: 0,
      ),
      Chart2DPageNew(
        index: 3,
        inputNumber: 0,
        initialChip: 0,
        nextChip: 0,
        positionX: 0,
        positionY: 0,
        members: 0,
        valueDisplay: 0,
        valueDisplayPrev: 0,
      ),
      Chart2DPageNew(
        index: 4,
        inputNumber: 0,
        initialChip: 0,
        nextChip: 0,
        positionX: 0,
        positionY: 0,
        members: 0,
        valueDisplay: 0,
        valueDisplayPrev: 0,
      ),
    ]);

    debugPrint("Game instances loaded: ${gameInstances.length}");
  }



void updateChartData({
  required List<int> newInputNumbers,
  required List<int> newInitialChips,
  required List<int> newNextChips,
  required List<int> newValueDisplay,
  required List<int> newValueDisplayPrev,
  required List<int> newMembers,
  required List<double> newPositionX,
  required List<double> newPositionY,
}) {
  bool shouldUpdate = false;
  // Update observable lists
  inputNumbers.assignAll(newInputNumbers);
  initialChips.assignAll(newInitialChips);
  nextChips.assignAll(newNextChips);
  valueDisplay.assignAll(newValueDisplay);
  valueDisplayPrev.assignAll(newValueDisplayPrev);
  members.assignAll(newMembers);
  positionX.assignAll(newPositionX);
  positionY.assignAll(newPositionY);



  // Ensure gameInstances has enough elements
  for (int i = 0; i < gameInstances.length && i < newInputNumbers.length; i++) {
    if (gameInstances[i].valueDisplay != newValueDisplay[i] || gameInstances[i].nextChip != newNextChips[i] ) {
      // Update only if valueDisplay has changed
      gameInstances[i] = Chart2DPageNew(
        index: i,
        inputNumber: newInputNumbers[i],
        initialChip: newInitialChips[i],
        nextChip: newNextChips[i],
        positionX: newPositionX[i],
        positionY: newPositionY[i],
        members: newMembers[i],
        valueDisplay: newValueDisplay[i],
        valueDisplayPrev: newValueDisplayPrev[i],
      );
      shouldUpdate = true;
    }
  }
  if (shouldUpdate) {
    gameInstances.refresh(); // Refresh only if necessary
    debugPrint("Game instances updated.");
  } else {
    debugPrint("No changes detected in game instances.");
    // gameInstances.refresh();
  }
}

}
