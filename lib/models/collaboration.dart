import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'collaboration.g.dart';

@HiveType(typeId: 0)
class Collaboration extends HiveObject {

    @HiveField(0)
    String title;

    @HiveField(1)
    DateTime deadline;

    // @HiveField(2)
    // List<Platforms> platforms;

    @HiveField(2)
    Fee fee;

    // @HiveField(4)
    // CollabState state;

    @HiveField(3)
    Requirements requirements;
    
    @HiveField(4)
    Partner partner;

    @HiveField(5)
    Script script;

    @HiveField(6)
    String id = Uuid().v1().toString();

    Collaboration({
        required this.title,
        required this.deadline,
        //required this.platforms,
        required this.fee,
        //required this.state,
        required this.requirements,
        required this.partner,
        required this.script
    });
}

@HiveType(typeId: 1)
class Script extends HiveObject {
    @HiveField(0)
    String content;

    Script({required this.content});
}

@HiveType(typeId: 2)
class Partner {
    @HiveField(0)
    String companyName;

    @HiveField(1)
    String industry;

    @HiveField(2)
    String name;

    @HiveField(3)
    String email;

    @HiveField(4)
    String phone;

    @HiveField(5)
    String customerNumber;

    Partner({
        required this.name,
        required this.email,
        required this.phone,
        required this.companyName,
        required this.industry,
        required this.customerNumber
    });
}

enum Platforms {
    Instagram, Tiktok, Youtube, Facebook, LinkedIn, Snapchat, Pinterest
}

enum CollabState {
   Accepted, Rejected, ContentCreated, ContentApproved, Completed
}

@HiveType(typeId: 3)
class Requirements {
  @HiveField(0)
  List<String> requirements;

  Requirements({required this.requirements});
}

@HiveType(typeId: 4)
class Fee {
    @HiveField(0)
    final double amount;

    @HiveField(1)
    final String currency;
    Fee({required this.amount, required this.currency});
}