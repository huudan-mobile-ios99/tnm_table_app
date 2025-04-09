part of 'timer_bloc.dart';


enum TimerStatus { initial, ticking, paused, finish }

class TimerState extends Equatable {
  final int duration;
  final TimerStatus status;

  const TimerState({
    required this.duration,
    required this.status,
  });

  factory TimerState.initial() {
    return const TimerState(
      duration: TimerBloc._defaultDuration, // Default duration
      status: TimerStatus.initial,
    );
  }

  TimerState copyWith({
    int? duration,
    TimerStatus? status,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [duration, status];
}