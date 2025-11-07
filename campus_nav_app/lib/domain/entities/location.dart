class Location {
  final double latitude;
  final double longitude;
  final String? label;

  Location({
    required this.latitude,
    required this.longitude,
    this.label,
  });
}