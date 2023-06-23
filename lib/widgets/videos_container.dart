import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'my_video_player.dart';

class VideosContainer extends StatefulWidget {
  const VideosContainer({super.key});

  @override
  State<VideosContainer> createState() => _VideosContainerState();
}

class _VideosContainerState extends State<VideosContainer> {
  /* Image Picker */
  ImageSource? _imageSource;
  final List<XFile> _videos = List.empty(growable: true);
  final _imagePicker = ImagePicker();

  // Scaffold State
  late ScaffoldMessengerState scaffoldState;

  @override
  void didChangeDependencies() {
    // updating scaffold context
    scaffoldState = ScaffoldMessenger.of(context);

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    // CLearing Scaffold State before popping
    scaffoldState.clearMaterialBanners();
    scaffoldState.clearSnackBars();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 196.spMax,
          width: 1.sw,
          alignment: Alignment.center,
          padding: EdgeInsets.all(5.spMax),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              style: BorderStyle.solid,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(32.r),
          ),

          // child
          child: _videos.isEmpty
              ? const Text(
                  'Upload videos to preview here',
                  textAlign: TextAlign.center,
                )
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, _) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Text(_videos[index].name),
                      leading: IconButton(
                        onPressed: () => setState(() {
                          _videos.removeAt(index);
                        }),
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => Dialog.fullscreen(
                            backgroundColor: Colors.black38,
                            child: MyVideoPlayer(_videos[index]),
                          ),
                        ),
                        child: const Text('Preview'),
                      ),
                    );
                  },
                  itemCount: _videos.length,
                ),
        ),

        // spacing
        SizedBox(height: 96.h),

        /* Uploader */
        ElevatedButton.icon(
          onPressed: _pickVideo,
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('Capture or Upload Videos'),
        ),
      ],
    );
  }

  /* Displays a Modal Bootm Sheet with Two Options for _imageSource required by ImagePicker in a Row  */
  Future _pickSource() async {
    return await showModalBottomSheet(
      constraints: BoxConstraints.tight(Size.fromHeight(256.h)),
      context: context,
      builder: (bottomSheetContext) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _imageSource = ImageSource.camera;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.camera),
              label: const Text("Camera"),
            ),
            const VerticalDivider(),
            TextButton.icon(
              onPressed: () {
                _imageSource = ImageSource.gallery;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.photo_album),
              label: const Text("Gallery"),
            )
          ],
        ),
      ),
    );
  }

/* No Image Source was specified. This can happen when the Modal Bottom Sheet was dismissed 
without providing the _imageSource value by tapping on either of the 
two sources: Camera or Gallery */
  bool _validateSource() {
    if (_imageSource == null) {
      scaffoldState.removeCurrentMaterialBanner();

      scaffoldState.showMaterialBanner(
        MaterialBanner(
          margin: const EdgeInsets.only(bottom: 16.0),
          content: const Text('Operation Cancelled by the User'),
          actions: [
            ElevatedButton(
              child: const Text('Dismiss'),
              onPressed: () => scaffoldState.clearMaterialBanners(),
            )
          ],
        ),
      );

      return false;
    }
    return true;
  }

/* Shows a SnackBar that displays that No image was picked or Captured by the User */
  void _noImagePickedOrCaptured() {
    scaffoldState.removeCurrentSnackBar();

    scaffoldState.showSnackBar(
      const SnackBar(
        content: Text('No video captured or selected by the user'),
      ),
    );
  }

  /* Image Picker Utilizer */
  void _pickVideo() async {
    // Pick the Image Source
    await _pickSource();

    // Check if Image Source is Null, Cancel the Operation
    if (_validateSource()) {
      /* Else Pick the Image File */
      _imagePicker.pickVideo(source: _imageSource!).then((value) {
        if (value != null) {
          /* Do Something with Video */
          setState(() {
            _videos.add(value);
          });
        } else {
          /* Show the SnackBar telling the user that no image was selected */
          _noImagePickedOrCaptured();
        }
        /* Set the _imageSource to be Null */
        _imageSource = null;
      });
    }
  }
}
