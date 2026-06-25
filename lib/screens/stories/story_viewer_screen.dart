import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbit/models/story_model.dart';
import 'package:orbit/providers/story_provider.dart';
import 'package:orbit/services/chat_services.dart';
import 'package:orbit/services/story_services.dart';
import 'package:orbit/widgets/story_header.dart';
import 'package:orbit/widgets/story_progress_bar.dart';
import 'package:orbit/widgets/story_reply_bar.dart';
import 'package:orbit/widgets/story_view_count.dart';
import 'package:provider/provider.dart';

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

  final TextEditingController _replyController = TextEditingController();
  late FocusNode _replyFocusNode;
  bool _isSendingReply = false;

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
    _replyFocusNode = FocusNode();
    _replyFocusNode.addListener(() {
      if(_replyFocusNode.hasFocus) {
        _progressController.stop();
      } else {
        if(!_progressController.isAnimating && _progressController.value < 1.0) {
          _progressController.forward();
        }
      }
    });
    _progressController.forward();
    _progressController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        _nextStory();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadNextStory();
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
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
                     return StoryProgressBar(
                         currentIndex: _currentIndex,
                         totalStories: widget.stories.length,
                         progress: _progressController.value
                     );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: StoryHeader(
                      story: story,
                      isOwner: _isOwner,
                      timeAgo: formatTimeAgo(story.createdAt),
                      onBack: () => Navigator.pop(context),
                      onDelete: _deleteCurrentStory
                  )
              ),
              if(_isOwner)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 0,
                right: 0,
                child: Center(
                  child: StoryViewCount(count: story.viewers.length, onTap: _showViewers)
                ),
              ),
              if(!_isOwner)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 12,
                    right: 12,
                    child: StoryReplyBar(controller: _replyController, focusNode: _replyFocusNode, onSend: _sendStoryReply, isSending: _isSendingReply,)
                )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _replyFocusNode.dispose();
    _replyController.dispose();
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
    _replyController.clear();
    _replyFocusNode.unfocus();
    if(_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _preloadNextStory();
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
    _replyController.clear();
    _replyFocusNode.unfocus();
    if(_currentIndex > 0){
      setState(() {
        _currentIndex--;
      });
      _preloadNextStory();
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
            if (viewers.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text("No views yet"),
                ),
              );
            }
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

  Future<void> _deleteCurrentStory() async {
    final story = widget.stories[_currentIndex];
    _progressController.stop();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Story"),
          content: const Text(
            "Are you sure you want to delete this story?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      if(mounted) {
        _progressController.forward();
      }
    });

    if (confirmed != true) return;

    if (!mounted) return;

    await context.read<StoryProvider>().deleteStory(
      story.storyId,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _sendStoryReply() async {
    if (_isSendingReply) return;
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _isSendingReply = true;
    });
    try {
      final story = widget.stories[_currentIndex];
      await ChatServices().sendMessage(
        receiverId: story.userId,
        text: text,
      );
      if (!mounted) return;
      _replyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reply sent"),
          duration: Duration(seconds: 1),
        ),
      );
    } finally {
      setState(() {
        _isSendingReply = false;
      });
    }
  }

  void _preloadNextStory() {
    if (_currentIndex >= widget.stories.length - 1) return;

    final nextStory = widget.stories[_currentIndex + 1];

    precacheImage(
      NetworkImage(nextStory.imageUrl),
      context,
    );
  }
}
