import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesPreview extends StatefulWidget {
  const ImagesPreview({super.key, required this.images});
  final List<String> images;

  @override
  State<ImagesPreview> createState() => _ImagesPreviewState();
}

class _ImagesPreviewState extends State<ImagesPreview> {
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    PageController controller = PageController(
      initialPage: 0,
      viewportFraction: isLandscape ? 0.5 : 1.0,
    );

    return SizedBox(
      height: isLandscape ? 0.5.sh : 0.3.sh,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView(
            controller: controller,
            onPageChanged: (idx) => setState(() {
              imageIndex = idx;
            }),
            physics: const ClampingScrollPhysics(),
            children: widget.images
                .map((img) => GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => Dialog.fullscreen(
                          backgroundColor: Colors.black54,
                          child: InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Image.network(
                                img,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Image.network(img),
                      ),
                    ))
                .toList(),
          ),
          Card(
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                '${imageIndex + 1} / ${widget.images.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
