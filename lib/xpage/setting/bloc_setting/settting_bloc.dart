import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/xpage/setup/model/settingslot.model.dart';
import '../../../service/service_api.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'setting_event.dart';
part 'setting_state.dart';

final service_api = ServiceAPIs();
const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SetttingBloc extends Bloc<SettingEvent, SettingState> {
  final http.Client httpClient;
  SetttingBloc({required this.httpClient}) : super(const SettingState()) {
    on<SettingFetched>(_onSettingFetched,transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onSettingFetched(SettingFetched event, Emitter<SettingState> emit) async {
    debugPrint("_onSettingFetched");
    try {
      if (state.status == SettingStatus.initial) {
        final posts = await service_api.findSettings();
        return emit(
          state.copyWith(
            status: SettingStatus.success,
            posts: posts!.list,
          ),
        );
      }
      final posts = await service_api.findSettings();
      posts!.list.isEmpty
          ? emit(state.copyWith(status: SettingStatus.failure))
          : emit(
              state.copyWith(
                status: SettingStatus.success,
                posts: List.of(state.posts)..addAll(posts.list),
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.failure));
    }
  }
}
