import 'package:flutter/material.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AppLifecycleServices extends StatefulWidget {
  final Widget child;
  const AppLifecycleServices({
    super.key,
    required this.child
  });

  @override
  State<AppLifecycleServices> createState() => _AppLifecycleServicesState();
}

class _AppLifecycleServicesState extends State<AppLifecycleServices> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state
      ) {
    final userProvider = context.read<UserProvider>();
    if (state == AppLifecycleState.resumed) {
      userProvider.updateOnlineStatus(true);
    }
    if(state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      userProvider.updateOnlineStatus(false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
