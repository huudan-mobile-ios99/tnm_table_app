import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tournament_client/xgame2d_table/chart/chart2DPage.dart';

part 'chartEvent.dart';
part 'chartState.dart';

// BLoC
class ChartStreamBloc extends Bloc<ChartStreamEvent, ChartStreamState> {
  ChartStreamBloc() : super(const ChartStreamState()) {
    // on<UpdateChartDataEvent>(_onUpdateChartData);
    on<UpdateChartDataEvent>(_onUpdateChartData);
  }


// void _onUpdateChartData(
//     UpdateChartDataEvent event, Emitter<ChartStreamState> emit) {
//     emit(state.copyWith(
//       status: ChartStreamStatus.initial,
//       inputNumbers: event.inputNumbers,
//       initialChips: event.initialChips,
//       nextChips: event.nextChips,
//       valueDisplay:event.valueDisplay,
//       valueDisplayPrev:event.valueDisplayPrev,
//       members: event.members.map((e) => e.toString()).toList()
//     ));
//   }
// }




void _onUpdateChartData(UpdateChartDataEvent event, Emitter<ChartStreamState> emit) {
  List<int> updateListIfChanged(List<int> oldList, List<int> newList) {
    return listEquals(oldList, newList) ? oldList : List.from(newList);
  }

  // Only create new lists if needed
  final newInputNumbers = updateListIfChanged(state.inputNumbers, event.inputNumbers);
  final newInitialChips = updateListIfChanged(state.initialChips, event.initialChips);
  final newNextChips = updateListIfChanged(state.nextChips, event.nextChips);
  final newValueDisplay = updateListIfChanged(state.valueDisplay, event.valueDisplay);
  final newValueDisplayPrev = updateListIfChanged(state.valueDisplayPrev, event.valueDisplayPrev);

  // Prevent unnecessary game instance recreation
  if (listEquals(state.inputNumbers, newInputNumbers) &&
      listEquals(state.valueDisplay, newValueDisplay)) {
    return; // No need to emit a new state
  }

  List<Map<String, dynamic>> gameConfigs = List.generate(event.inputNumbers.length, (index) {
    return {
      "inputNumber": event.inputNumbers[index],
      "initialChip": event.initialChips[index],
      "nextChip": event.nextChips[index],
      "positionX": event.positionX[index],
      "positionY": event.positionY[index],
      "valueDisplay": event.valueDisplay[index],
      "valueDisplayPrev": event.valueDisplayPrev[index],
      "members": event.members[index],
      "index": index,
      "played": false, // Default value
    };
  });

  List<Chart2DPage> gameInstances = gameConfigs.map((config) => Chart2DPage(
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

  emit(state.copyWith(
    status: ChartStreamStatus.updated,
    inputNumbers: newInputNumbers,
    initialChips: newInitialChips,
    nextChips: newNextChips,
    valueDisplay: newValueDisplay,
    valueDisplayPrev: newValueDisplayPrev,
    members: event.members.map((e) => e.toString()).toList(),
    gameInstances: gameInstances,
  ));
}

}








// Future<void> _onUpdateChartDataGame(UpdateChartDataEvent event, Emitter<ChartStreamState> emit) async {
  // await Future.delayed(Duration(milliseconds: 25)); // 🔥 Small delay

//   List<Chart2DPage> newGameInstances = List.generate(event.inputNumbers.length, (index) {
//     return Chart2DPage(
//       inputNumber: event.inputNumbers[index],
//       initialChip: event.initialChips[index],
//       nextChip: event.nextChips[index],
//       positionX: event.positionX[index],
//       positionY: event.positionY[index],
//       index: index,
//       played: false,
//       valueDisplay: event.valueDisplay[index],
//       valueDisplayPrev: event.valueDisplayPrev[index],
//       members: event.members[index],
//     );
//   });

//   emit(state.copyWith(
//     status: ChartStreamStatus.updated,
//     inputNumbers: event.inputNumbers,
//     initialChips: event.initialChips,
//     nextChips: event.nextChips,
//     valueDisplay: event.valueDisplay,
//     valueDisplayPrev: event.valueDisplayPrev,
//     members: event.members.map((e) => e.toString()).toList(),
//     gameInstances: List.from(newGameInstances),
//   ));
// }



// void _onUpdateChartDataGameV2(UpdateChartDataEvent event, Emitter<ChartStreamState> emit) {
//   List<Chart2DPage> newGameInstances = List.generate(event.inputNumbers.length, (index) {
//     return Chart2DPage(
//       inputNumber: event.inputNumbers[index],
//       initialChip: event.initialChips[index],
//       nextChip: event.nextChips[index],
//       positionX: event.positionX[index],
//       positionY: event.positionY[index],
//       index: index,
//       played: false,
//       valueDisplay: event.valueDisplay[index],
//       valueDisplayPrev: event.valueDisplayPrev[index],
//       members: event.members[index],
//     );
//   });

//   emit(state.copyWith(
//     status: ChartStreamStatus.updated,
//     inputNumbers: event.inputNumbers,
//     initialChips: event.initialChips,
//     nextChips: event.nextChips,
//     valueDisplay: event.valueDisplay,
//     valueDisplayPrev: event.valueDisplayPrev,
//     members: event.members.map((e) => e.toString()).toList(),
//     gameInstances: List.from(newGameInstances), // 🔥 Ensure new reference
//   ));
// }
