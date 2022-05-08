// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = 0;

  @override
  Conversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversation(
      starter: fields[1] as Contact,
      messages: (fields[2] as List).cast<Message>(),
      uuid: fields[0] as String,
      updatedAt: fields[3] as DateTime,
      contact: fields[5] as Contact,
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(1)
      ..write(obj.starter)
      ..writeByte(5)
      ..write(obj.contact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation(
    starter: Contact.fromJson(json['starter'] as Map<String, dynamic>),
    messages: (json['messages'] as List<dynamic>)
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList(),
    uuid: json['uuid'] as String,
    updatedAt: DateTime.parse(json['updated-at'] as String),
    contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'messages': instance.messages.map((m) => m.toJson()).toList(),
      'updated-at': instance.updatedAt.toIso8601String(),
      'starter': instance.starter.toJson(),
      'contact': instance.contact.toJson(),
    };
