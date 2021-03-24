import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _controller.setLooping(false);
    _controller.addListener(() {
      if(_controller.value.position == _controller.value.duration){
        setState(() {
            _controller.seekTo(Duration(minutes: 0));
        });
      }
    });
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                _buildAspectRatio(),
                _buildControlls()
              ]
            );
          } else {
            return Container(child: CircularProgressIndicator(), padding: const EdgeInsets.all(20.0));
          }
        }
    );
  }

  Widget _buildControlls(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayPauseButton(),
        _buildReplayButton()
      ]
    );
  }

  Widget _buildAspectRatio(){
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller)
    );
  }

  Widget _buildPlayPauseButton(){
    return IconButton(
        icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        tooltip: 'Play',
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        }
    );
  }

  Widget _buildReplayButton(){
    return IconButton(
        icon: Icon(Icons.replay),
        tooltip: 'Reiniciar',
        onPressed: () {
          _controller.seekTo(Duration(seconds: 0));
        }
    );
  }
}