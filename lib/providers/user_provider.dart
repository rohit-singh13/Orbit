import 'package:flutter/cupertino.dart';
import 'package:orbit/models/user_model.dart';
import 'package:orbit/services/firestore_services.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _user;
  UserModel? get user => _user;
  final FirestoreServices _firestoreServices = FirestoreServices();
  Future<void> loadUser(String uid) async {
    _user = await _firestoreServices.getUser(uid);
    notifyListeners();
  }
  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }
}