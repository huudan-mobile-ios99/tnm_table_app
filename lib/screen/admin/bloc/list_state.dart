part of 'list_bloc.dart';


enum ListStatus { initial, success, failure }

class ListState extends Equatable{
  const ListState({
    this.status = ListStatus.initial,
    this.posts = const <Ranking>[],
    this.hasReachedMax = false,
  });
  final ListStatus status;
  final List<Ranking> posts;
  final bool hasReachedMax;

  ListState copyWith({
    ListStatus? status,
    List<Ranking>? posts,
    bool? hasReachedMax,
  }) {
    return ListState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  @override
  String toString() {
    return 'listState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}

