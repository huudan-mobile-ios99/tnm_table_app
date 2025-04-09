part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

// Start timer with a custom duration
class StartTimer extends TimerEvent {
  final int durationInSeconds; // Duration passed from the UI

  const StartTimer({required this.durationInSeconds});

  @override
  List<Object> get props => [durationInSeconds];
}

class Tick extends TimerEvent {
  final int duration;

  const Tick(this.duration);

  @override
  List<Object> get props => [duration];
}

class PauseTimer extends TimerEvent {}

class ResumeTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}