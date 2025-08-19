import 'dart:convert';

import 'package:collabflow/models/collaboration.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CollaborationsRepository extends ChangeNotifier {

  final Box<Collaboration> _box = Hive.box<Collaboration>('collaborations');
  List<Collaboration> get collaborations => List.unmodifiable(_box.values.toList());

  void createCollaboration(Collaboration collaboration){
    _box.add(collaboration);
    notifyListeners();
  }

  void delete(String id) {
    final collaboration = _box.values.firstWhere((collab) => collab.id == id, orElse: () => throw Exception("Collaboration not found"));
    _box.delete(collaboration.key);
    notifyListeners();
  }

  void updateCollaboration(Collaboration updatedCollaboration) {
    final index = _box.values.toList().indexWhere((collab) => collab.id == updatedCollaboration.id);
    if (index != -1) {
      _box.putAt(index, updatedCollaboration);
      notifyListeners();
    } else {
      throw Exception("Collaboration not found");
    }
  }
  
}