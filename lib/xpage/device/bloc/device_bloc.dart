import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/lib/models/deviceModel.dart';
import '../../../service/service_api.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'device_event.dart';
part 'device_state.dart';

final service_api = ServiceAPIs();
const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final http.Client httpClient;
  DeviceBloc({required this.httpClient}) : super(const DeviceState()) {
    on<DeviceFetched>(_onListFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onListFetched(
      DeviceFetched event, Emitter<DeviceState> emit) async {
    debugPrint("_onListFetched Devices");
    if (state.hasReachedMax) return;
    try {
      if (state.status == DeviceStatus.initial) {
        final posts = await service_api.listDevicesAll();
        return emit(
          state.copyWith(
            status: DeviceStatus.success,
            posts: posts.data,
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: DeviceStatus.failure));
    }
  }
}
