class Collaboration {
    String title;
    DateTime deadline;
    List<Platforms> platforms;
    Fee fee;
    CollabState state;
    Requirements requirements;
    Partner partner;
    Script script;

    Collaboration({
        required this.title,
        required this.deadline,
        required this.platforms,
        required this.fee,
        required this.state,
        required this.requirements,
        required this.partner,
        required this.script
    });
}

class Script {
    String content;
    Script({required this.content});
}

class Partner {
    String companyName;
    String industry;
    String name;
    String email;
    String phone;
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

class Requirements {
  List<String> requirements;
  Requirements({required this.requirements});
}

class Fee {
    final double amount;
    final String currency;
    Fee({required this.amount, required this.currency});
}