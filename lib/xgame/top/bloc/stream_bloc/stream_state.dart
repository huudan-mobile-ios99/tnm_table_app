part of 'stream_bloc.dart';


enum StreamStatus { initial, success, failure }

class StreamMState extends Equatable{
  const StreamMState({
    this.status = StreamStatus.initial,
    this.posts = const <StreamDataModel>[],
  });
  final StreamStatus status;
  final List<StreamDataModel> posts;

  StreamMState copyWith({
    StreamStatus? status,
    List<StreamDataModel>? posts,
  }) {
    return StreamMState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
    );
  }
  @override
  String toString() {
    return 'StreamMState { status: $status, posts: ${posts.length} }';
  }

  @override
  List<Object> get props => [status, posts];
}

