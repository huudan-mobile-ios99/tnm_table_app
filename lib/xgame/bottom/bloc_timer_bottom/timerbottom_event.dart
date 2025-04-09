part of 'timerbottom_bloc.dart';

abstract class TimerBottomEvent extends Equatable {
  const TimerBottomEvent();

  @override
  List<Object> get props => [];
}

// Start timer with a custom duration
class StartTimer extends TimerBottomEvent {
  final int durationInSeconds; // Duration passed from the UI

  const StartTimer({required this.durationInSeconds});

  @override
  List<Object> get props => [durationInSeconds];
}

class Tick extends TimerBottomEvent {
  final int duration;
  const Tick(this.duration);

  @override
  List<Object> get props => [duration];
}

class PauseTimer extends TimerBottomEvent {}

class ResumeTimer extends TimerBottomEvent {}

class StopTimer extends TimerBottomEvent {}

class SetTimer extends TimerBottomEvent{}