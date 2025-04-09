part of 'settting_bloc.dart';
enum SettingStatus { initial, success, failure }

class SettingState extends Equatable {
  const SettingState({
    this.status = SettingStatus.initial,
     this.posts = const <SettingSlot>[],
  });

  final SettingStatus status;
  final List<SettingSlot> posts;

  SettingState copyWith({
    SettingStatus? status,
    List<SettingSlot>? posts,
  }) {
    return SettingState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return 'SettingState { status: $status, posts: ${posts.length} }';
  }

  @override
  List<Object?> get props => [status, posts];
}