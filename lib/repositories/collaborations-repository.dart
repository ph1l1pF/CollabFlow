
import 'package:collabflow/models/collaboration.dart';
import 'package:collabflow/repositories/notifications-repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CollaborationsRepository extends ChangeNotifier {

  late NotificationsRepository _notificationsRepository;

  CollaborationsRepository({required NotificationsRepository notificationsRepo}) {
      _notificationsRepository = notificationsRepo;
  }


  final Box<Collaboration> _box = Hive.box<Collaboration>('collaborations');
  List<Collaboration> get collaborations => List.unmodifiable(_box.values.toList());

  void createCollaboration(Collaboration collaboration, {BuildContext? context}){
    _box.add(collaboration);

    if(collaboration.deadline.sendNotification && context != null) {
      _notificationsRepository.scheduleNotification(collaboration, context);
    }
    notifyListeners();
  }

  void delete(Collaboration collaboration) {
    _box.delete(collaboration.key);
    notifyListeners();

    _notificationsRepository.cancelNotification(collaboration);
  }

  void deleteById(String id) {
    final collaboration = _box.values.firstWhere((collab) => collab.id == id, orElse: () => throw Exception("Collaboration not found"));
    _box.delete(collaboration.key);
    notifyListeners();
    _notificationsRepository.cancelNotification(collaboration);
  }

  void updateCollaboration(Collaboration updatedCollaboration, {BuildContext? context}) {
    final index = _box.values.toList().indexWhere((collab) => collab.id == updatedCollaboration.id);
    if (index != -1) {
      _box.putAt(index, updatedCollaboration);
      notifyListeners();
    } else {
      throw Exception("Collaboration not found");
    }

    _notificationsRepository.cancelNotification(updatedCollaboration);
    if(updatedCollaboration.deadline.sendNotification && context != null) {
      _notificationsRepository.scheduleNotification(updatedCollaboration, context);
    }
  }
  
}