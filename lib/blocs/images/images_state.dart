part of 'images_cubit.dart';

abstract class ImagesState extends Equatable {
  final List<XFile> images;

  const ImagesState({required this.images});

  @override
  List<Object> get props => [images];
}

class ImagesInitial extends ImagesState {
  const ImagesInitial({required super.images});
}

class ImagesUpdate extends ImagesState {
  const ImagesUpdate({required super.images});
}
