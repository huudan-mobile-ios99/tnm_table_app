part of 'jackpot_bloc.dart';

abstract class JackpotDropEvent extends Equatable {
  const JackpotDropEvent();

  @override
  List<Object?> get props => [];
}

class JackpotDropFetched extends JackpotDropEvent {}