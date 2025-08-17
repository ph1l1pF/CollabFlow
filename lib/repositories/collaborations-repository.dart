import 'dart:convert';

import 'package:collabflow/models/collaboration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollaborationsRepository extends ChangeNotifier {

  final List<Collaboration> _collaborations = [];

  List<Collaboration> get collaborations => List.unmodifiable(_collaborations);

  // Define methods for managing collaborations
  void createCollaboration(Collaboration collaboration) async{
    _collaborations.add(collaboration);

     final prefs = await SharedPreferences.getInstance();
    final data = _collaborations.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList("collaborations", data);

    notifyListeners();
  }
  
}