// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaboration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollaborationAdapter extends TypeAdapter<Collaboration> {
  @override
  final int typeId = 0;

  @override
  Collaboration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collaboration(
      title: fields[0] as String,
      deadline: fields[1] as Deadline,
      fee: fields[2] as Fee,
      requirements: fields[3] as Requirements,
      partner: fields[4] as Partner,
      script: fields[5] as Script,
      notes: fields[7] as String,
      state: fields[8] as CollabState,
    )..id = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, Collaboration obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.deadline)
      ..writeByte(2)
      ..write(obj.fee)
      ..writeByte(3)
      ..write(obj.requirements)
      ..writeByte(4)
      ..write(obj.partner)
      ..writeByte(5)
      ..write(obj.script)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollaborationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScriptAdapter extends TypeAdapter<Script> {
  @override
  final int typeId = 1;

  @override
  Script read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Script(
      content: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Script obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScriptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartnerAdapter extends TypeAdapter<Partner> {
  @override
  final int typeId = 2;

  @override
  Partner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Partner(
      name: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      companyName: fields[0] as String,
      industry: fields[1] as String,
      customerNumber: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Partner obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.industry)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.customerNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RequirementsAdapter extends TypeAdapter<Requirements> {
  @override
  final int typeId = 3;

  @override
  Requirements read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Requirements(
      requirements: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Requirements obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.requirements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequirementsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FeeAdapter extends TypeAdapter<Fee> {
  @override
  final int typeId = 4;

  @override
  Fee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fee(
      amount: fields[0] as double,
      currency: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Fee obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeadlineAdapter extends TypeAdapter<Deadline> {
  @override
  final int typeId = 6;

  @override
  Deadline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deadline(
      date: fields[0] as DateTime,
      sendNotification: fields[1] as bool,
      notificationDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Deadline obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.sendNotification)
      ..writeByte(2)
      ..write(obj.notificationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeadlineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CollabStateAdapter extends TypeAdapter<CollabState> {
  @override
  final int typeId = 5;

  @override
  CollabState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CollabState.FirstTalks;
      case 1:
        return CollabState.ContractToSign;
      case 2:
        return CollabState.ScriptToProduce;
      case 3:
        return CollabState.InProduction;
      case 4:
        return CollabState.ContentEditing;
      case 5:
        return CollabState.ContentFeedback;
      case 6:
        return CollabState.Finished;
      default:
        return CollabState.FirstTalks;
    }
  }

  @override
  void write(BinaryWriter writer, CollabState obj) {
    switch (obj) {
      case CollabState.FirstTalks:
        writer.writeByte(0);
        break;
      case CollabState.ContractToSign:
        writer.writeByte(1);
        break;
      case CollabState.ScriptToProduce:
        writer.writeByte(2);
        break;
      case CollabState.InProduction:
        writer.writeByte(3);
        break;
      case CollabState.ContentEditing:
        writer.writeByte(4);
        break;
      case CollabState.ContentFeedback:
        writer.writeByte(5);
        break;
      case CollabState.Finished:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollabStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
