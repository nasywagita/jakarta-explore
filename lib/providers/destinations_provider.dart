import 'package:flutter/material.dart';
import '../data/models/destination_model.dart';
import '../data/repositories/destinations_repository.dart';

class DestinationsProvider with ChangeNotifier {
  final DestinationsRepository _repository;

  DestinationsProvider({required DestinationsRepository repository})
    : _repository = repository;

  List<DestinationModel> _destinations = [];
  List<DestinationModel> get destinations => _destinations;

  List<DestinationModel> _filteredDestinations = [];
  List<DestinationModel> get filteredDestinations => _filteredDestinations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentCategory = 'Semua';
  String get currentCategory => _currentCategory;

  Future<void> fetchDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await _repository.getDestinations();
      _filterDestinations();
    } catch (e) {
      _destinations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      _filterDestinations();
      notifyListeners();
    }
  }

  void searchDestinations(String query) {
    if (query.isEmpty) {
      _filterDestinations();
    } else {
      _filteredDestinations = _destinations.where((dest) {
        final matchCategory =
            _currentCategory == 'Semua' ||
            dest.category.toLowerCase() == _currentCategory.toLowerCase();
        final matchSearch =
            dest.name.toLowerCase().contains(query.toLowerCase()) ||
            dest.location.toLowerCase().contains(query.toLowerCase());
        return matchCategory && matchSearch;
      }).toList();
    }
    notifyListeners();
  }

  void _filterDestinations() {
    if (_currentCategory == 'Semua') {
      _filteredDestinations = List.from(_destinations);
    } else {
      _filteredDestinations = _destinations
          .where(
            (dest) =>
                dest.category.toLowerCase() == _currentCategory.toLowerCase(),
          )
          .toList();
    }
  }
}
