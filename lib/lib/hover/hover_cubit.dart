import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit to manage the hover state
class HoverCubit extends Cubit<bool> {
  HoverCubit() : super(false);

  void onHoverEnter() => emit(true);
  void onHoverExit() => emit(false);
}