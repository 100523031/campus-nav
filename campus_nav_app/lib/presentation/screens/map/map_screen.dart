import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/campus_repository.dart';
import '../../../domain/entities/building.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del Campus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuildingSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.accessible),
            onPressed: () {
              context.read<CampusRepository>().toggleAccessibilityFilter();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.read<CampusRepository>().showOnlyAccessible
                        ? 'Mostrando solo lugares accesibles'
                        : 'Mostrando todos los lugares',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CampusRepository>(
        builder: (context, repository, child) {
          return Stack(
            children: [
              // Mapa interactivo con zoom y pan
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                child: Stack(
                  children: [
                    // Imagen del mapa
                    Image.asset(
                      'assets/images/campus_map.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              const Text(
                                'Error al cargar el mapa',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Verifica que campus_map.jpg esté en assets/images/',
                                style: TextStyle(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Marcadores de edificios
                    ...repository.buildings.map((building) {
                      return _BuildingMarker(
                        building: building,
                        isSelected: repository.selectedBuilding?.id == building.id,
                        onTap: () {
                          repository.selectBuilding(building);
                          _showBuildingDetails(context, building);
                        },
                      );
                    }),
                  ],
                ),
              ),
              
              // Controles de zoom
              Positioned(
                right: 16,
                bottom: 100,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'zoom_in',
                      onPressed: () {
                        final newValue = _transformationController.value.clone()
                          ..scale(1.2);
                        _transformationController.value = newValue;
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'zoom_out',
                      onPressed: () {
                        final newValue = _transformationController.value.clone()
                          ..scale(0.8);
                        _transformationController.value = newValue;
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'reset_zoom',
                      onPressed: () {
                        _transformationController.value = Matrix4.identity();
                      },
                      child: const Icon(Icons.center_focus_strong),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBuildingDetails(BuildContext context, Building building) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIconForType(building.type), size: 36, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    building.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (building.description != null)
              Text(
                building.description!,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16),
            if (building.facilities != null && building.facilities!.isNotEmpty) ...[
              const Text(
                'Servicios disponibles:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: building.facilities!.map((facility) {
                  return Chip(
                    label: Text(facility),
                    backgroundColor: Colors.blue.shade50,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigation),
                    label: const Text('Cómo llegar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ruta a ${building.name} (función en desarrollo)'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'edificio':
        return Icons.business;
      case 'servicio':
        return Icons.room_service;
      case 'parking':
        return Icons.local_parking;
      case 'transporte':
        return Icons.train;
      case 'residencia':
        return Icons.home;
      default:
        return Icons.location_on;
    }
  }
}

class _BuildingMarker extends StatelessWidget {
  final Building building;
  final bool isSelected;
  final VoidCallback onTap;

  const _BuildingMarker({
    required this.building,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: building.longitude * MediaQuery.of(context).size.width - 20,
      top: building.latitude * MediaQuery.of(context).size.height - 40,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              color: isSelected ? Colors.red : Colors.blue,
              size: isSelected ? 40 : 32,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  building.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BuildingSearchDelegate extends SearchDelegate<Building?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final repository = context.read<CampusRepository>();
    repository.setSearchQuery(query);
    final results = repository.buildings;

    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No se encontraron resultados',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final building = results[index];
        return ListTile(
          leading: Icon(_getIconForType(building.type)),
          title: Text(building.name),
          subtitle: Text(building.description ?? building.type),
          onTap: () {
            repository.selectBuilding(building);
            close(context, building);
          },
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'edificio':
        return Icons.business;
      case 'servicio':
        return Icons.room_service;
      case 'parking':
        return Icons.local_parking;
      case 'transporte':
        return Icons.train;
      case 'residencia':
        return Icons.home;
      default:
        return Icons.location_on;
    }
  }
}