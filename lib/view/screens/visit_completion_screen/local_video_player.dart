import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  final bool showControls;

  const LocalVideoPlayer({
    super.key,
    required this.videoPath,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));

    try {
      await _controller.initialize();

      await _controller.setLooping(true);

      if (widget.autoPlay) {
        await _controller.play();
      }

      if (!mounted) return;

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      debugPrint('Video initialize error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: widget.showControls
          ? () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          if (widget.showControls && !_controller.value.isPlaying)
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 35,
              ),
            ),
        ],
      ),
    );
  }
}
