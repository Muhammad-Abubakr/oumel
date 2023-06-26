import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  ImagesCubit() : super(ImagesInitial(images: List.empty()));

  /* Add Image */
  void addImage(List<XFile> xFile) {
    emit(ImagesUpdate(images: [...state.images, ...xFile]));
  }

  /* Remove Image */
  void removeImage(XFile xFile) {
    // remove the image
    List<XFile> updatedImages = [...(state.images..remove(xFile))];

    emit(ImagesUpdate(images: updatedImages));
  }

  /* Check if no images */
  bool isEmpty() {
    return state.images.isEmpty;
  }

  /* Check if there are images */
  bool isNotEmpty() {
    return state.images.isNotEmpty;
  }
}
