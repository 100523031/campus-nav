import 'package:flutter/foundation.dart';
import '../../domain/entities/building.dart';
import '../models/campus_data.dart';

class CampusRepository extends ChangeNotifier {
  final List<Building> _buildings = CampusData.buildings;
  Building? _selectedBuilding;
  String _searchQuery = '';
  bool _showOnlyAccessible = false;

  List<Building> get buildings {
    var filtered = _buildings;
    
    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = CampusData.searchBuildings(_searchQuery);
    }
    
    // Filtrar por accesibilidad
    if (_showOnlyAccessible) {
      filtered = filtered.where((b) => b.isAccessible).toList();
    }
    
    return filtered;
  }

  Building? get selectedBuilding => _selectedBuilding;
  String get searchQuery => _searchQuery;
  bool get showOnlyAccessible => _showOnlyAccessible;

  void selectBuilding(Building? building) {
    _selectedBuilding = building;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleAccessibilityFilter() {
    _showOnlyAccessible = !_showOnlyAccessible;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _showOnlyAccessible = false;
    _selectedBuilding = null;
    notifyListeners();
  }
}