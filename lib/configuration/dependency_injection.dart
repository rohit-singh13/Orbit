import 'package:orbit/providers/friend_provider.dart';
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
  ];
}