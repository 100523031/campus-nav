import 'location.dart';

class NavigationRoute {
  final List<Location> waypoints;
  final double distanceInMeters;
  final int estimatedTimeInMinutes;
  final bool isAccessible;
  final List<String> instructions;

  NavigationRoute({
    required this.waypoints,
    required this.distanceInMeters,
    required this.estimatedTimeInMinutes,
    required this.isAccessible,
    required this.instructions,
  });

  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toInt()} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }
}