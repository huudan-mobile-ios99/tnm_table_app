import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/screen/admin/model/rankingList.dart';
import '../../../service/service_api.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'list_event.dart';
part 'list_state.dart';

final service_api = ServiceAPIs();
const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ListBloc extends Bloc<ListEvent, ListState> {
  final http.Client httpClient;
  ListBloc({required this.httpClient}) : super(const ListState()){
    on<ListFetched>(
      _onListFetched,
      transformer: throttleDroppable(throttleDuration)
    );
  }

  Future<void> _onListFetched(ListFetched event,Emitter<ListState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ListStatus.initial) {
        final posts = await service_api.fetchRanking();
        return emit(
          state.copyWith(
            status: ListStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      final posts = await service_api.fetchRanking(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ListStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: ListStatus.failure));
    }
  }

}
