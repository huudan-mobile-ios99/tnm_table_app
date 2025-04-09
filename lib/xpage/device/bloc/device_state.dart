part of 'device_bloc.dart';


enum DeviceStatus { initial, success, failure }

class DeviceState extends Equatable{
  const DeviceState({
    this.status = DeviceStatus.initial,
    this.posts = const <DeviceModelData>[],
    this.hasReachedMax = false,
  });
  final DeviceStatus status;
  final List<DeviceModelData> posts;
  final bool hasReachedMax;

  DeviceState copyWith({
    DeviceStatus? status,
    List<DeviceModelData>? posts,
    bool? hasReachedMax,
  }) {
    return DeviceState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  @override
  String toString() {
    return 'DeviceState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}

