import 'package:flutter/material.dart';
import '../data/models/destination_model.dart';
import '../data/services/database_service.dart';

class BookmarkProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  String? _userId;
  List<String> _bookmarkedIds = [];

  List<String> get bookmarkedIds => _bookmarkedIds;

  // Called when AuthProvider updates
  void updateUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      _loadBookmarks();
    }
  }

  Future<void> _loadBookmarks() async {
    if (_userId == null) {
      _bookmarkedIds = [];
      notifyListeners();
      return;
    }

    try {
      final user = await _dbService.getUserById(_userId!);
      _bookmarkedIds = List<String>.from(user.bookmarkedIds);
    } catch (e) {
      _bookmarkedIds = [];
    }
    notifyListeners();
  }

  bool isBookmarked(String destinationId) {
    return _bookmarkedIds.contains(destinationId);
  }

  Future<void> toggleBookmark(DestinationModel destination) async {
    if (_userId == null) return;

    final isExisting = isBookmarked(destination.id);
    if (isExisting) {
      _bookmarkedIds.remove(destination.id);
      await _dbService.removeBookmark(_userId!, destination.id);
    } else {
      _bookmarkedIds.add(destination.id);
      await _dbService.addBookmark(_userId!, destination.id);
    }
    notifyListeners();
  }
}

