import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/campus_repository.dart';
import '../../../data/models/campus_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Navigator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'UC3M Campus Leganés',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '¿A dónde quieres ir?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Buscador
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar edificios, aulas, servicios...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                context.read<CampusRepository>().setSearchQuery(value);
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.push('/map');
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Botón Ver Mapa
            ElevatedButton.icon(
              onPressed: () {
                context.read<CampusRepository>().clearFilters();
                context.push('/map');
              },
              icon: const Icon(Icons.map, size: 28),
              label: const Text(
                'VER MAPA DEL CAMPUS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Edificios
            _buildSectionTitle(context, 'Edificios', Icons.business),
            const SizedBox(height: 12),
            _buildBuildingsList(context, CampusData.getEdificios()),
            
            const SizedBox(height: 24),
            
            // Servicios
            _buildSectionTitle(context, 'Servicios', Icons.room_service),
            const SizedBox(height: 12),
            _buildServicesList(context, CampusData.getServicios()),
            
            const SizedBox(height: 24),
            
            // Accesos rápidos
            _buildSectionTitle(context, 'Accesos rápidos', Icons.directions),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _QuickAccessCard(
                  icon: Icons.accessible,
                  title: 'Rutas\nAccesibles',
                  color: Colors.green,
                  onTap: () {
                    context.read<CampusRepository>().toggleAccessibilityFilter();
                    context.push('/map');
                  },
                ),
                _QuickAccessCard(
                  icon: Icons.train,
                  title: 'Transporte',
                  color: Colors.purple,
                  onTap: () {
                    final metro = CampusData.getBuildingById('metro_leganes');
                    if (metro != null) {
                      context.read<CampusRepository>().selectBuilding(metro);
                      context.push('/map');
                    }
                  },
                ),
                _QuickAccessCard(
                  icon: Icons.local_parking,
                  title: 'Parking',
                  color: Colors.orange,
                  onTap: () {
                    context.read<CampusRepository>().setSearchQuery('parking');
                    context.push('/map');
                  },
                ),
                _QuickAccessCard(
                  icon: Icons.menu_book,
                  title: 'Biblioteca',
                  color: Colors.blue,
                  onTap: () {
                    final biblioteca = CampusData.getBuildingById('biblioteca');
                    if (biblioteca != null) {
                      context.read<CampusRepository>().selectBuilding(biblioteca);
                      context.push('/map');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBuildingsList(BuildContext context, List buildings) {
    return Column(
      children: buildings.map<Widget>((building) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                building.id.contains('edificio_') 
                    ? building.id.replaceAll('edificio_', '')
                    : building.name[0],
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              building.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(building.description ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.read<CampusRepository>().selectBuilding(building);
              context.push('/map');
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesList(BuildContext context, List services) {
    return Column(
      children: services.map<Widget>((service) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              _getServiceIcon(service.name),
              color: Colors.orange,
            ),
            title: Text(
              service.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(service.description ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.read<CampusRepository>().selectBuilding(service);
              context.push('/map');
            },
          ),
        );
      }).toList(),
    );
  }

  IconData _getServiceIcon(String serviceName) {
    if (serviceName.contains('Cafetería')) return Icons.local_cafe;
    if (serviceName.contains('Gimnasio')) return Icons.fitness_center;
    if (serviceName.contains('Banco')) return Icons.account_balance;
    if (serviceName.contains('Reprografía')) return Icons.print;
    if (serviceName.contains('Delegación')) return Icons.groups;
    if (serviceName.contains('Biblioteca')) return Icons.menu_book;
    return Icons.room_service;
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}