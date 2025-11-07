import '../../domain/entities/building.dart';

class CampusData {
  static final List<Building> buildings = [
    // EDIFICIOS PRINCIPALES
    Building(
      id: 'edificio_1',
      name: 'Edificio Agustín de Betancourt',
      type: 'edificio',
      latitude: 0.42,
      longitude: 0.52,
      description: 'Edificio 1 - Agustín de Betancourt',
      isAccessible: true,
      facilities: ['aulas', 'laboratorios', 'despachos', 'banco', 'reprografía', 'delegación de estudiantes'],
    ),
    Building(
      id: 'edificio_2',
      name: 'Edificio Sabatini',
      type: 'edificio',
      latitude: 0.52,
      longitude: 0.48,
      description: 'Edificio 2 - Sabatini',
      isAccessible: true,
      facilities: ['aulas', 'laboratorios', 'cafetería'],
    ),
    Building(
      id: 'edificio_3',
      name: 'Edificio Rey Pastor',
      type: 'edificio',
      latitude: 0.70,
      longitude: 0.68,
      description: 'Edificio 3 - Rey Pastor (Biblioteca)',
      isAccessible: true,
      facilities: ['biblioteca', 'aulas', 'salas de estudio'],
    ),
    Building(
      id: 'edificio_4',
      name: 'Edificio Torres Quevedo',
      type: 'edificio',
      latitude: 0.62,
      longitude: 0.58,
      description: 'Edificio 4 - Torres Quevedo',
      isAccessible: true,
      facilities: ['aulas', 'laboratorios', 'despachos'],
    ),
    Building(
      id: 'edificio_5',
      name: 'Edificio Padre Soler',
      type: 'edificio',
      latitude: 0.32,
      longitude: 0.62,
      description: 'Edificio 5 - Padre Soler',
      isAccessible: true,
      facilities: ['aulas', 'salón de grados', 'auditorio', 'cafetería'],
    ),
    Building(
      id: 'edificio_6',
      name: 'Centro Deportivo',
      type: 'edificio',
      latitude: 0.25,
      longitude: 0.72,
      description: 'Edificio 6 - Centro Deportivo',
      isAccessible: true,
      facilities: ['gimnasio', 'instalaciones deportivas', 'vestuarios'],
    ),
    Building(
      id: 'edificio_7',
      name: 'Edificio Juan Benet',
      type: 'edificio',
      latitude: 0.22,
      longitude: 0.38,
      description: 'Edificio 7 - Juan Benet',
      isAccessible: true,
      facilities: ['aulas', 'laboratorios'],
    ),
    Building(
      id: 'edificio_8',
      name: 'Residencia de estudiantes Fernando Abril Martorell',
      type: 'residencia',
      latitude: 0.15,
      longitude: 0.25,
      description: 'Edificio 8 - Residencia de estudiantes',
      isAccessible: true,
      facilities: ['alojamiento', 'comedor', 'salas comunes'],
    ),

    // SERVICIOS ESPECÍFICOS
    Building(
      id: 'cafeteria_edificio_5',
      name: 'Cafetería (Edificio 5)',
      type: 'servicio',
      latitude: 0.32,
      longitude: 0.62,
      description: 'Cafetería principal en el Edificio Padre Soler',
      isAccessible: true,
      facilities: ['comida', 'bebidas', 'wifi', 'mesas'],
    ),
    Building(
      id: 'cafeteria_edificio_2',
      name: 'Cafetería (Edificio 2)',
      type: 'servicio',
      latitude: 0.52,
      longitude: 0.48,
      description: 'Cafetería en el Edificio Sabatini',
      isAccessible: true,
      facilities: ['comida', 'bebidas', 'wifi'],
    ),
    Building(
      id: 'gimnasio',
      name: 'Gimnasio (Edificio 6)',
      type: 'servicio',
      latitude: 0.25,
      longitude: 0.72,
      description: 'Gimnasio y centro deportivo',
      isAccessible: true,
      facilities: ['gimnasio', 'máquinas', 'actividades deportivas'],
    ),
    Building(
      id: 'banco',
      name: 'Banco',
      type: 'servicio',
      latitude: 0.42,
      longitude: 0.48,
      description: 'Sucursal bancaria (Edificio 1)',
      isAccessible: true,
      facilities: ['cajero', 'banco', 'servicios financieros'],
    ),
    Building(
      id: 'reprografia',
      name: 'Reprografía',
      type: 'servicio',
      latitude: 0.38,
      longitude: 0.48,
      description: 'Servicio de reprografía (Edificio 1)',
      isAccessible: true,
      facilities: ['fotocopias', 'impresión', 'encuadernación'],
    ),
    Building(
      id: 'delegacion_estudiantes',
      name: 'Delegación de estudiantes',
      type: 'servicio',
      latitude: 0.44,
      longitude: 0.50,
      description: 'Delegación de estudiantes (Edificio 1)',
      isAccessible: true,
      facilities: ['información', 'representación estudiantil'],
    ),

    // OTROS PUNTOS DE INTERÉS
    Building(
      id: 'biblioteca',
      name: 'Biblioteca Rey Pastor',
      type: 'servicio',
      latitude: 0.70,
      longitude: 0.68,
      description: 'Biblioteca principal del campus',
      isAccessible: true,
      facilities: ['libros', 'estudio', 'ordenadores', 'wifi', 'salas de grupo'],
    ),
    Building(
      id: 'metro_leganes',
      name: 'Metro Leganés Central',
      type: 'transporte',
      latitude: 0.85,
      longitude: 0.20,
      description: 'Estación de Metro Leganés Central (Línea 12)',
      isAccessible: true,
      facilities: ['metro', 'transporte público'],
    ),
  ];

  static List<Building> searchBuildings(String query) {
    if (query.isEmpty) return buildings;
    
    final lowerQuery = query.toLowerCase();
    return buildings.where((building) {
      return building.name.toLowerCase().contains(lowerQuery) ||
             building.type.toLowerCase().contains(lowerQuery) ||
             (building.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  static Building? getBuildingById(String id) {
    try {
      return buildings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Building> getEdificios() {
    return buildings.where((b) => b.type == 'edificio' || b.type == 'residencia').toList();
  }

  static List<Building> getServicios() {
    return buildings.where((b) => b.type == 'servicio').toList();
  }
}


