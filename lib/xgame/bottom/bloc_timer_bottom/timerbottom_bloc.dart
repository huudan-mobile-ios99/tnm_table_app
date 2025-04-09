import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timerbottom_state.dart';
part 'timerbottom_event.dart';

class TimerBottomBloc extends Bloc<TimerBottomEvent, TimerBottomState> {
  static const int _defaultDuration = 300; // 5 minutes in seconds
  Timer? _timer;
  bool _isPaused = false;

  TimerBottomBloc({int initialDuration = _defaultDuration}) : super(TimerBottomState.initial(initialDuration: initialDuration)) {
    // Start timer with custom or default duration
    on<StartTimer>((event, emit) {
      emit(state.copyWith(
        duration: event.durationInSeconds ?? _defaultDuration, // Use custom or default duration
        status: TimerBottomStatus.ticking,
      ));
      _startTimer();
    });
     

    on<SetTimer>((event, emit) {
      _timer?.cancel();
      emit(state.copyWith(
        status: TimerBottomStatus.set,
        duration: _defaultDuration, // Reset timer to default duration
      ));
    });
     
    //set timer to default initial value

    // Pause timer
    on<PauseTimer>((event, emit) {
      _isPaused = true;
      _timer?.cancel();
      emit(state.copyWith(status: TimerBottomStatus.paused));
    });

    // Resume timer
    on<ResumeTimer>((event, emit) {
      if (_isPaused) {
        _isPaused = false;
        emit(state.copyWith(status: TimerBottomStatus.ticking));
        _startTimer();
      }
    });

    // Stop timer
    on<StopTimer>((event, emit) {
      _timer?.cancel();
      emit(state.copyWith(
        status: TimerBottomStatus.finish,
        duration: 0  , // Reset timer to default duration
      ));
    });

    // Tick event
    on<Tick>((event, emit) {
      if (event.duration > 0) {
        emit(state.copyWith(
          duration: event.duration,
          status: TimerBottomStatus.ticking,
        ));
      } else {
        _timer?.cancel();
        emit(state.copyWith(
          duration: 0,
          status: TimerBottomStatus.finish,
        ));
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // final newDuration = state.duration - 1;
      // add(Tick(newDuration));
      final newDuration = state.duration - 1;

      if (newDuration >= 0) {
        add(Tick(newDuration));
      } else {
        _timer?.cancel();
        add(const Tick(0)); // Ensures the timer stops at 0
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
