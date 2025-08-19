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
      deadline: fields[1] as DateTime,
      fee: fields[2] as Fee,
      requirements: fields[3] as Requirements,
      partner: fields[4] as Partner,
      script: fields[5] as Script,
      notes: fields[7] as String,
    )..id = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, Collaboration obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.notes);
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
