import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(VideosInitial(videos: List.empty()));

  /* Add Video */
  void addVideo(XFile xFile) {
    emit(VideosUpdate(videos: [...state.videos, xFile]));
  }

  /* Remove Video */
  void removeVideo(XFile xFile) {
    // remove the video
    List<XFile> updatedVideos = [...(state.videos..remove(xFile))];

    emit(VideosUpdate(videos: updatedVideos));
  }

  Future<XFile> getVideo(Uri uri) async {
    final res = await get(uri);

    return XFile.fromData(res.bodyBytes);
  }

  /* Check if no videos */
  bool isEmpty() {
    return state.videos.isEmpty;
  }

  /* Check if there are videos */
  bool isNotEmpty() {
    return state.videos.isNotEmpty;
  }
}
