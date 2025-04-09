part of 'jackpot_bloc.dart';


enum JackpotStatus { initial, success, failure }

class JackpotState extends Equatable {
  final JackpotStatus status;
  final List<JackpotModelData> posts;


  const JackpotState({
    required this.status,
    this.posts = const <JackpotModelData>[],
  });


  JackpotState copyWith({
    JackpotStatus? status,
    List<JackpotModelData>? post,
  }) {
    return JackpotState(
      status: status ?? this.status,
      posts: posts,

    );

  }
  @override
  String toString() {
    return 'JackpotState { status: $status, posts: ${posts.length} }';
  }

  @override
  List<Object> get props => [status, posts];
}