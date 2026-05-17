import '../models/destination_model.dart';
import '../local/mock_destinations.dart';

class DestinationsRepository {
  // Simulate network delay and fetch all destinations
  Future<List<DestinationModel>> getDestinations() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return mockDestinations;
  }

  // Fetch destination by ID
  Future<DestinationModel?> getDestinationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return mockDestinations.firstWhere((dest) => dest.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch destinations by category
  Future<List<DestinationModel>> getDestinationsByCategory(
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (category.toLowerCase() == 'semua') {
      return mockDestinations;
    }
    return mockDestinations
        .where((dest) => dest.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Search destinations
  Future<List<DestinationModel>> searchDestinations(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return mockDestinations;

    return mockDestinations.where((dest) {
      return dest.name.toLowerCase().contains(query.toLowerCase()) ||
          dest.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
