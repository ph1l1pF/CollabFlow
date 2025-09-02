import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'collaboration.g.dart';

@HiveType(typeId: 0)
class Collaboration extends HiveObject {

    @HiveField(0)
    String title;

    @HiveField(1)
    Deadline deadline;

    // @HiveField(2)
    // List<Platforms> platforms;

    @HiveField(2)
    Fee fee;

    @HiveField(3)
    Requirements requirements;
    
    @HiveField(4)
    Partner partner;

    @HiveField(5)
    Script script;

    @HiveField(6)
    String id = Uuid().v1().toString();

    @HiveField(7)
    String notes;

    @HiveField(8)
    CollabState state;

    Collaboration({
        required this.title,
        required this.deadline,
        //required this.platforms,
        required this.fee,
        required this.requirements,
        required this.partner,
        required this.script,
        required this.notes,
        required this.state,
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

@HiveType(typeId: 5)
enum CollabState {
  @HiveField(0)
  FirstTalks,
  @HiveField(1)
  ContractToSign,
  @HiveField(2)
  ScriptToProduce,
  @HiveField(3)
  InProduction,
  @HiveField(4)
  ContentEditing,
  @HiveField(5)
  ContentFeedback,
  @HiveField(6)
  Finished
}

@HiveType(typeId: 6)
class Deadline {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  bool sendNotification;

  @HiveField(2)
  DateTime? notificationDate;

  Deadline({required this.date, required this.sendNotification, this.notificationDate});

  static Deadline defaultDeadline() {
    return Deadline(date: DateTime.now(), sendNotification: false, notificationDate: null);
  }
}
