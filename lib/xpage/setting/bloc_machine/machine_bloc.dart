import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/lib/models/stationmodel.dart';
import '../../../service/service_api.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'machine_event.dart';
part 'machine_state.dart';


final service_api = ServiceAPIs();
const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ListMachineBloc extends Bloc<ListMachineEvent, ListMachineState> {
  final http.Client httpClient;
  ListMachineBloc({required this.httpClient}) : super(const ListMachineState()){
    on<ListMachineFetched>(
      _onListMachineFetched,
      transformer: throttleDroppable(throttleDuration)
    );
  }

  Future<void> _onListMachineFetched(ListMachineFetched event,Emitter<ListMachineState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ListMachineStatus.initial) {
        final posts = await service_api.listStationData();
        return emit(
          state.copyWith(
            status: ListMachineStatus.success,
            posts: posts!.list,
            hasReachedMax: false,
          ),
        );
      }
      // final posts = await service_api.listStationData();
      // posts!.list.isEmpty
      //     ? emit(state.copyWith(hasReachedMax: true))
      //     : emit(
      //         state.copyWith(
      //           status: ListMachineStatus.success,
      //           posts: List.of(state.posts)..addAll(posts.list),
      //           hasReachedMax: false,
      //         ),
      //       );
    } catch (e) {
      emit(state.copyWith(status: ListMachineStatus.failure));
    }
  }

}
