import 'package:orbit/providers/chat_provider.dart';
import 'package:orbit/providers/comment_provider.dart';
import 'package:orbit/providers/friend_provider.dart';
import 'package:orbit/providers/post_provider.dart';
import 'package:orbit/providers/search_provider.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class DependencyInjection {
  static final providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
        create: (_) => UserProvider(),
    ),
    ChangeNotifierProvider(
        create: (_) => FriendProvider(),
    ),
    ChangeNotifierProvider(
        create: (_) => SearchProvider()
    ),
    ChangeNotifierProvider(
        create: (_) => ChatProvider()
    ),
    ChangeNotifierProvider(
        create: (_) => PostProvider()
    ),
    ChangeNotifierProvider(
        create: (_) => CommentProvider()
    ),
  ];
}