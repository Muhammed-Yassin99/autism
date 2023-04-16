import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoPlayer extends StatefulWidget {
  @override
  _FullscreenVideoPlayerState createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isControllerInitialized = false;
  bool _hasControllerError = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/wash_hand.mp4')
        ..addListener(() {
          if (_controller.value.hasError) {
            setState(() {
              _hasControllerError = true;
            });
          }
        });
      await _controller.initialize();
      setState(() {
        _isControllerInitialized = true;
      });
    } catch (e) {
      print('Error initializing video player: $e');
      setState(() {
        _hasControllerError = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return CircularProgressIndicator(); // Show loading spinner instead
    }
    if (_hasControllerError) {
      return Text('Error loading video');
    }
    return GestureDetector(
      onTap: () {
        _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play();
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
