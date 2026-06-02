import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Introscreen extends StatefulWidget{
  const Introscreen ({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  late VideoPlayerController _videoController;
  bool isready = false;

  @override
  void initState (){
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/Intro.mp4')..initialize().then((_) {
      if (mounted) {
        setState(() {
          isready = true;
        });
      }
      _videoController.setLooping(true);
      _videoController.play();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: isready
          ? SizedBox.expand(
          child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
              ),
          ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      )
      );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }


}