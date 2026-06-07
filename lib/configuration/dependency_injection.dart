import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class DependencyInjection {
  static final providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(), //auth provider
    ),
  ];
}