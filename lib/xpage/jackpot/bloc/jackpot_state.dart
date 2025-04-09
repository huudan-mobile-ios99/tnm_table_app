part of 'jackpot_bloc.dart';


enum JackpotDropStatus { initial, success, failure }


class JackpotDropState extends Equatable {
  const JackpotDropState({
    this.status = JackpotDropStatus.initial,
    this.posts,
    this.hasReachedMax = false,
  });

  final JackpotDropStatus status;
  final JackpotHistoryModel? posts;
  final bool hasReachedMax;

  JackpotDropState copyWith({
    JackpotDropStatus? status,
    JackpotHistoryModel? posts,
    bool? hasReachedMax,
  }) {
    return JackpotDropState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    final postCount = posts?.data.length ?? 0;
    return 'jackpotdrop {status: $status, hasReachedMax: $hasReachedMax, posts: $postCount}';
  }

  @override
  List<Object?> get props => [status, posts, hasReachedMax];
}
