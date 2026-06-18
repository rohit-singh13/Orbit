import 'package:flutter/cupertino.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/services/search_services.dart';

class SearchProvider extends ChangeNotifier{
  final SearchServices _searchServices = SearchServices();
  List<UserModel> _results = [];
  List<UserModel> get results => _results;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchUsers(
      String query
      ) async {
    _isLoading = true;
    notifyListeners();

    _results = await _searchServices.searchUsers(query);
    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _results = [];
    _isLoading = false;
    notifyListeners();
  }
}