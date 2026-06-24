import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/services/story_services.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;
  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  final StoryServices _storyServices = StoryServices();

  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
    _markViewed();
  }

  Future<void> _markViewed() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _storyServices.markStoryViewed(
      widget.stories[_currentIndex].storyId,
      currentUserId,
    );
  }

  Future<void> _nextStory() async {
    if(_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      await _markViewed();
    } else {
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _previousStory() async {
    if(_currentIndex > 0){
      setState(() {
        _currentIndex--;
      });
      await _markViewed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                    story.imageUrl,
                    fit: BoxFit.cover,
                  )
              ),

              Positioned(
                top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: story.userImageUrl != null ? NetworkImage(story.userImageUrl!) : null,
                      ),

                      SizedBox(width: 10,),

                      Text(story.userName, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),

                      const Spacer(),

                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, icon: Icon(Icons.close, color: Colors.white,)
                      )
                    ],
                  )
              ),

              // previous tap area
              Positioned(
                left: 0,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _previousStory,
                  )),

              // Next tap area
              Positioned(
                top: 0,
                  right: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _nextStory,
                  ))

            ],
          )
      ),
    );
  }
}
