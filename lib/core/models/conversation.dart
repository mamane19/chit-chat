import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/message.dart';

part 'conversation.g.dart';

/// A moodel that holds data for a conversation.
@JsonSerializable(fieldRename: FieldRename.kebab)
@HiveType(typeId: 0)
class Conversation with EquatableMixin {
  /// Initializes a new [Conversation].
  const Conversation({
    required this.starter,
    required this.messages,
    required this.uuid,
    required this.updatedAt,
    required this.contact,
  });

  /// Parses a [json] Map into an instance of [Conversation].
  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  /// Parses this [Conversation] into a json Map.
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  /// Conversation's unique ID.
  @HiveField(0)
  final String uuid;

  /// The messages of this conversation.
  @HiveField(2)
  final List<Message> messages;

  /// The date when this conversation has been updated.
  ///
  /// This is usually the date when the last message has been sent.
  @HiveField(3)
  final DateTime updatedAt;

  /// The contact who started the chat.
  @HiveField(1)
  final Contact starter;

  /// The correspondant
  @HiveField(5)
  final Contact contact;

  /// The contacts involved in this chat.
  List<Contact> get contacts => [starter, contact];

  @override
  List<Object?> get props => [uuid, starter, contact, messages, updatedAt];

  /// Copies this [Conversation] and update the passed fields.
  Conversation copyWith({
    Contact? starter,
    Contact? contact,
    String? uuid,
    List<Message>? messages,
    DateTime? updatedAt,
  }) =>
      Conversation(
        contact: contact ?? this.contact,
        starter: starter ?? this.starter,
        messages: messages ?? this.messages,
        uuid: uuid ?? this.uuid,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
