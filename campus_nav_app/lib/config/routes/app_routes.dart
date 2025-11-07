import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/map/map_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String map = '/map';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: map,
        builder: (context, state) => const MapScreen(),
      ),
    ],
  );
}