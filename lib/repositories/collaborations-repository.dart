import 'package:collabflow/models/collaboration.dart';

class CollaborationsRepository {

  final List<Collaboration> _collaborations = [];

  List<Collaboration> get collaborations => List.unmodifiable(_collaborations);

  // Define methods for managing collaborations
  void createCollaboration(Collaboration collaboration){
    _collaborations.add(collaboration);
  }
  
}