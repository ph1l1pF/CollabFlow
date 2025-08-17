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
  
}