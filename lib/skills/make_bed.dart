// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideoPlayer5 extends StatefulWidget {
  const FullscreenVideoPlayer5({super.key});

  @override
  _FullscreenVideoPlayer5State createState() => _FullscreenVideoPlayer5State();
}

class _FullscreenVideoPlayer5State extends State<FullscreenVideoPlayer5> {
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
      _controller = VideoPlayerController.asset('assets/videos/make_bed.mp4')
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
      if (kDebugMode) {
        print('Error initializing video player: $e');
      }
      setState(() {
        _hasControllerError = true;
      });
    }
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return const CircularProgressIndicator(); // Show loading spinner instead
    }
    if (_hasControllerError) {
      return const Text('Error loading video');
    }
    return GestureDetector(
      onTap: () {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
      },
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
