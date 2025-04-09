part of 'chartBloc.dart';

enum ChartStreamStatus { initial, updated, failure ,}
class ChartStreamState extends Equatable {
  final ChartStreamStatus status;
  final List<int> inputNumbers;
  final List<int> initialChips;
  final List<int> nextChips;
  final List<int> valueDisplay;
  final List<int> valueDisplayPrev;
  final List<String> members;
  final List<Chart2DPage> gameInstances;

  const ChartStreamState({
    this.status = ChartStreamStatus.initial,
    this.inputNumbers = const [],
    this.initialChips = const [],
    this.nextChips = const [],
    this.valueDisplay = const [],
    this.valueDisplayPrev = const [],
    this.members = const [],
    this.gameInstances = const [],
  });

  @override
  List<Object?> get props => [
    status,
    List.from(inputNumbers),
    List.from(initialChips),
    List.from(nextChips),
    List.from(valueDisplay),
    List.from(valueDisplayPrev),
    List.from(members),
    List.from(gameInstances),
  ];

  ChartStreamState copyWith({
    ChartStreamStatus? status,
    List<int>? inputNumbers,
    List<int>? initialChips,
    List<int>? nextChips,
    List<int>? valueDisplay,
    List<int>? valueDisplayPrev,
    List<String>? members,
    List<Chart2DPage>? gameInstances,
  }) {
    return ChartStreamState(
      status: status ?? this.status,
      inputNumbers: inputNumbers ?? this.inputNumbers,
      initialChips: initialChips ?? this.initialChips,
      nextChips: nextChips ?? this.nextChips,
      valueDisplay: valueDisplay ?? this.valueDisplay,
      valueDisplayPrev: valueDisplayPrev ?? this.valueDisplayPrev,
      members: members ?? this.members,
      gameInstances: gameInstances ?? this.gameInstances,
    );
  }
}
