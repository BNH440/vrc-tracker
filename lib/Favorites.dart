import 'dart:developer';

import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  final List<String> _favoriteTeams = [];
  final List<String> _favoriteComps = [];

  List<String> get favoriteTeams => _favoriteTeams;
  List<String> get favoriteComps => _favoriteComps;

  void addTeam(String id) {
    _favoriteTeams.add(id);
    notifyListeners();
  }

  void addComp(String id) {
    _favoriteComps.add(id);
    notifyListeners();
  }

  void removeTeam(String id) {
    _favoriteTeams.remove(id);
    notifyListeners();
  }

  void removeComp(String id) {
    _favoriteComps.remove(id);
    notifyListeners();
  }

  void toggleTeam(String id) {
    if (_favoriteTeams.contains(id)) {
      removeTeam(id);
    } else {
      addTeam(id);
    }
  }

  void toggleComp(String id) {
    log("toggled $id");
    if (_favoriteComps.contains(id)) {
      removeComp(id);
    } else {
      addComp(id);
    }
  }
}
