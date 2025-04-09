part of 'chartBloc.dart';

abstract class ChartStreamEvent extends Equatable {
  const ChartStreamEvent();

  @override
  List<Object?> get props => [];
}

class UpdateChartDataEvent extends ChartStreamEvent {
  final List<int> inputNumbers;
  final List<int> initialChips;
  final List<int> nextChips;
  final List<int> valueDisplay;
  final List<int> valueDisplayPrev;
  final List<int> members;
  final List<double> positionX;
  final List<double> positionY;
  // final List<Chart2DPage>? gameInstances;


  const UpdateChartDataEvent({
    required this.inputNumbers,
    required this.initialChips,
    required this.nextChips,

    required this.members,
    required this.positionX,
    required this.positionY,

    required this.valueDisplay,
    required this.valueDisplayPrev,
    // required this.gameInstances,
  });

  @override
  List<Object?> get props => [
  inputNumbers,
  initialChips,
  nextChips,

  members,
  positionX,
  positionY,

  valueDisplay,
  valueDisplayPrev,

  // gameInstances,
  ];
}
