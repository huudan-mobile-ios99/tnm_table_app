import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_client/xgame2d_table/view/Chart2DPageRanking.dart';

class ChartControllerRanking extends GetxController {
  RxList<int> inputNumbers = <int>[].obs;
  RxList<int> initialChips = <int>[].obs;
  RxList<int> nextChips = <int>[].obs;
  RxList<int> valueDisplay = <int>[].obs;
  RxList<int> valueDisplayPrev = <int>[].obs;
  RxList<int> members = <int>[].obs;
  RxList<double> positionX = <double>[].obs;
  RxList<double> positionY = <double>[].obs;
  var gameInstances = <Chart2DPageRanking>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGamesRanking();
    debugPrint("ChartControllerRanking: Game instances initialized: ${gameInstances.length}");
  }

 void loadGamesRanking() {
    gameInstances.addAll([
      Chart2DPageRanking(
        index: 0,
        inputNumber: 1,
        initialChip: 100,
        nextChip: 100,
        positionX: 0,
        positionY: 985,
        members: 1,
        valueDisplay: 1111,
        valueDisplayPrev: 1111,
      ),
      Chart2DPageRanking(
        index: 1,
        inputNumber: 2,
        initialChip: 100,
        nextChip: 100,
        positionX: 0,
        positionY: 985,
        members: 2,
        valueDisplay: 2222,
        valueDisplayPrev: 2222,
      ),
      Chart2DPageRanking(
        index: 2,
        inputNumber: 3,
        initialChip: 100,
        nextChip: 100,
        positionX: 0,
        positionY: 985,
        members: 3,
        valueDisplay: 3333,
        valueDisplayPrev: 3333,
      ),
      Chart2DPageRanking(
        index: 3,
        inputNumber: 4,
        initialChip: 100,
        nextChip: 100,
        positionX: 0,
        positionY: 985,
        members: 4,
        valueDisplay: 4444,
        valueDisplayPrev: 4444,
      ),
      Chart2DPageRanking(
        index: 4,
        inputNumber: 5,
        initialChip: 100,
        nextChip: 100,
        positionX: 0,
        positionY: 985,
        members: 5,
        valueDisplay: 5555,
        valueDisplayPrev: 5555,
      ),
    ]);

    debugPrint("loadGamesRanking:Game instances loaded: ${gameInstances.length}");
  }


void updateChartDataRanking({
  required List<int> newInputNumbers,
  required List<int> newInitialChips,
  required List<int> newNextChips,
  required List<int> newValueDisplay,
  required List<int> newValueDisplayPrev,
  required List<int> newMembers,
}) {
  bool shouldUpdate = false;

  // Update observable lists
  inputNumbers.assignAll(newInputNumbers);
  initialChips.assignAll(newInitialChips);
  nextChips.assignAll(newNextChips);
  valueDisplay.assignAll(newValueDisplay);
  valueDisplayPrev.assignAll(newValueDisplayPrev);
  members.assignAll(newMembers);

  // Ensure gameInstances has enough elements
  for (int i = 0; i < gameInstances.length && i < newInputNumbers.length; i++) {
    if (gameInstances[i].valueDisplay != newValueDisplay[i] || gameInstances[i].nextChip != newNextChips[i]) {
      // Retain original positionX and positionY
      double originalPosX = gameInstances[i].positionX;
      double originalPosY = gameInstances[i].positionY;

      // Update only if valueDisplay or nextChip has changed
      gameInstances[i] = Chart2DPageRanking(
        index: i,
        inputNumber: newInputNumbers[i],
        initialChip: newInitialChips[i],
        nextChip: newNextChips[i],
        positionX: originalPosX, // Keep original X position
        positionY: originalPosY, // Keep original Y position
        members: newMembers[i],
        valueDisplay: newValueDisplay[i],
        valueDisplayPrev: newValueDisplayPrev[i],
      );
      shouldUpdate = true;
    }
  }

  gameInstances.refresh(); // Refresh only if necessary
  if (shouldUpdate) {
    gameInstances.refresh(); // Refresh only if necessary
    debugPrint("Game instances updated.");
  } else {
    debugPrint("No changes detected in game instances.");
  }
}

}
