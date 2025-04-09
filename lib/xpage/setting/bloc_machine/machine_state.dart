part of 'machine_bloc.dart';


enum ListMachineStatus { initial, success, failure }

class ListMachineState extends Equatable{
  const ListMachineState({
    this.status = ListMachineStatus.initial,
    this.posts = const <StationModel>[],
    this.hasReachedMax = false,
  });
  final ListMachineStatus status;
  final List<StationModel> posts;
  final bool hasReachedMax;

  ListMachineState copyWith({
    ListMachineStatus? status,
    List<StationModel>? posts,
    bool? hasReachedMax,
  }) {
    return ListMachineState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  @override
  String toString() {
    return 'ListMachineState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}

