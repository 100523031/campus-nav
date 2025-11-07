class Building {
  final String id;
  final String name;
  final String type; // edificio, aula, laboratorio, servicio
  final double latitude;
  final double longitude;
  final String? description;
  final bool isAccessible;
  final List<String>? facilities;

  Building({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.description,
    this.isAccessible = false,
    this.facilities,
  });
}