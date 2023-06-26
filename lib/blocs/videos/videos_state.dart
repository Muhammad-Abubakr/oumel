part of 'videos_cubit.dart';

abstract class VideosState extends Equatable {
  final List<XFile> videos;

  const VideosState({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideosInitial extends VideosState {
  const VideosInitial({required super.videos});
}

class VideosUpdate extends VideosState {
  const VideosUpdate({required super.videos});
}
