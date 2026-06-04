import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class IntroScreen extends StatefulWidget{
  const IntroScreen ({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _videoController;
  bool isReady = false;
  bool showContent = false;

  @override
  void initState (){
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/Intro.mp4')..initialize().then((_) {
      if (mounted) {
        setState(() {
          isReady = true;
        });
      }
      _videoController.setLooping(true);
      _videoController.play();

      Future.delayed(
        const Duration(milliseconds: 500),
          () {
          if(mounted) {
            setState(() {
              showContent = true;
            });
          }
          }
      );
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: isReady
      ? Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
          
          Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
                offset: showContent? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 800,),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                  opacity: showContent? 1 : 0,
                  duration: const Duration(
                    milliseconds: 800
                  ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    bottom: 60,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/logo/logo.png",
                        height: 150,
                        width: 150,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Your people. Your space. Your orbit.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 170),

                      CustomButton(
                        text: "Create Your Orbit",
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.signup,
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      CustomButton(
                        text: "Return to Your Orbit",
                        backgroundColor: const Color(0xff06B6D4),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )
      : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }


}