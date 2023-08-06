import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyVideoPlayer extends StatefulWidget {
  final XFile? file;
  final String? uri;

  const MyVideoPlayer(this.file, {this.uri, super.key});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  // Initializing controller
  bool isReady = false;
  late final VideoPlayerController _videoPlayerController;
  late final CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings();

  @override
  void initState() {
    if (widget.file != null) {
      _videoPlayerController = VideoPlayerController.file(File(widget.file!.path))
        ..initialize().then((_) => setState(() => isReady = true));
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.uri!)
        ..initialize().then((_) => setState(() => isReady = true));
    }

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );

    super.initState();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isReady
        ? CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
