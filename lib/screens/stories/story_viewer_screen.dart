import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin{
  final StoryServices _storyServices = StoryServices();

  late int _currentIndex;
  late AnimationController _progressController;
  bool get _isOwner => widget.stories[_currentIndex].userId == FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
    _markViewed();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky
    );
    _progressController = AnimationController(
        vsync: this,
      duration: const Duration(seconds: 5)
    );
    _progressController.forward();
    _progressController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPressStart: (_) {
            _progressController.stop();
          },
          onLongPressEnd: (_) {
            _progressController.forward();
          },
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;

            if(details.globalPosition.dx < width / 2) {
              _previousStory();
            } else {
              _nextStory();
            }
          },

          onVerticalDragEnd: (details) {
            if(details.primaryVelocity != null && details.primaryVelocity! < -300) {
              if(_isOwner) _showViewers();
            }
          },

          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                  child: SizedBox.expand(
                    child: Image.network(
                      story.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if(progress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [Colors.black54, Colors.transparent,],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                child: AnimatedBuilder(
                   animation: _progressController,
                  builder: (context, child) {
                     return Row(
                       children: List.generate(
                           widget.stories.length,
                               (index) {
                             return Expanded(
                                 child: Container(
                                   margin: const EdgeInsets.symmetric(horizontal: 2),
                                   height: 3,
                                   decoration: BoxDecoration(
                                     color: Colors.white24,
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   child: LayoutBuilder(
                                       builder: (context, constraints) {
                                         double progress;
                                         if(index < _currentIndex) {
                                           progress = 1;
                                         } else if (index > _currentIndex) {
                                           progress = 0;
                                         } else {
                                           progress = _progressController.value;
                                         }
                                         return Align(
                                           alignment: Alignment.centerLeft,
                                           child: Container(
                                             width: constraints.maxWidth * progress,
                                             decoration: BoxDecoration(
                                                 color: Colors.white,
                                                 borderRadius: BorderRadius.circular(10)
                                             ),
                                           ),
                                         );
                                       }
                                   ),
                                 )
                             );
                           }
                       ),
                     );
                  },
                ),
              ),
              SizedBox(height: 10,),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),

                      CircleAvatar(
                        radius: 20,
                        backgroundImage: story.userImageUrl != null
                            ? NetworkImage(story.userImageUrl!)
                            : null,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          story.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        formatTimeAgo(story.createdAt),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(_isOwner)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _showViewers,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6,),
                          Text("${story.viewers.length}", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    super.dispose();
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
      _progressController
      ..reset()
      ..forward();
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
      _progressController
      ..reset()
      ..forward();
      await _markViewed();
    }
  }

  String formatTimeAgo(
      DateTime createdAt
      ) {
    final diff = DateTime.now().difference(createdAt);
    if(diff.inMinutes < 1) {
      return "now";
    }
    if(diff.inHours < 1) {
      return "${diff.inMinutes}m";
    }
    return "${diff.inHours}h";
  }

  Future<void> _showViewers() async {
    final story = widget.stories[_currentIndex];
    _progressController.stop();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      builder: (_) {
        return FutureBuilder(
          future: _storyServices.getStoryViewers(
            story.viewers,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final viewers = snapshot.data!;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                children: [
                  SizedBox(height: 12,),
                  Text("${viewers.length} Views", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  const Divider(),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: viewers.length,
                      itemBuilder: (context, index) {
                        final user = viewers[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.imageUrl != null
                                ? NetworkImage(user.imageUrl!)
                                : null,
                          ),
                          title: Text(user.name),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _progressController.forward();
    });
  }
}
