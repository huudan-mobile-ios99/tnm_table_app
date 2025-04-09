import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/models/jackModel.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:http/http.dart' as http;

part 'jackpot_state.dart';
part 'jackpot_event.dart';

final service_api = ServiceAPIs();
const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class JackpotBloc extends Bloc<JackpotEvent, JackpotState> {
  final http.Client httpClient;
  JackpotBloc({required this.httpClient})
      : super(const JackpotState(status: JackpotStatus.initial)) {
    on<JackpotFetched>(_onlistJackPotFetched,  transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onlistJackPotFetched( JackpotFetched event, Emitter<JackpotState> emit) async {
    debugPrint('_onlistJackPotFetched ');
    try {
      if (state.status == JackpotStatus.initial) {
        final posts = await service_api.getJackpotAll();
        debugPrint('_onlistJackPotFetched post: ${posts!.data}');
        return emit(
          state.copyWith(
            status: JackpotStatus.success,
            post: posts.data,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: JackpotStatus.failure));
    }
  }
}
