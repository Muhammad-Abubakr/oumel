import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImagesContainer extends StatefulWidget {
  const ImagesContainer({super.key});

  @override
  State<ImagesContainer> createState() => _ImagesContainerState();
}

class _ImagesContainerState extends State<ImagesContainer> {
  /* Image Picker */
  List<XFile> _images = List.empty(growable: true);
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
          // styling
          alignment: Alignment.center,
          height: 300.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              style: BorderStyle.solid,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(32.r),
          ),

          // child
          child: _images.isEmpty
              ? const Text(
                  'Upload images to preview here',
                  textAlign: TextAlign.center,
                )
              : LayoutBuilder(
                  builder: (context, constraints) => ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.h),
                    separatorBuilder: (context, _) => const VerticalDivider(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Card(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => Dialog.fullscreen(
                                backgroundColor: Colors.black38,
                                child: InteractiveViewer(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24.r),
                                    child: Image.file(
                                      File(_images[index].path),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: Image.file(
                              File(_images[index].path),
                              fit: BoxFit.scaleDown,
                              width: constraints.maxHeight,
                              height: constraints.maxHeight,
                            ),
                          ),

                          /* Remove Button */
                          Padding(
                            padding: EdgeInsets.all(8.0.h),
                            child: InkWell(
                              onTap: () => setState(() {
                                _images.removeAt(index);
                              }),
                              child: Icon(
                                Icons.remove_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemCount: _images.length,
                  ),
                ),
        ),
        // spacing
        SizedBox(height: 96.h),

        /* Uploader */
        ElevatedButton.icon(
          onPressed: _pickMultipleImages,
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('Upload Images'),
        ),
      ],
    );
  }

  /* Image Picker Utilizer */
  void _pickMultipleImages() async {
    _imagePicker.pickMultiImage().then((value) {
      debugPrint('${value.length}');

      setState(() {
        _images = value;
      });
    });
  }
}
