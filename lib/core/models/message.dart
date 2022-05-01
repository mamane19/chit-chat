import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xave/core/models/contact.dart';

part 'message.g.dart';

/// A model that holds the data of a message.
@JsonSerializable(fieldRename: FieldRename.kebab)
@HiveType(typeId: 1)
class Message with EquatableMixin {
  /// Initializes a new [Message].
  const Message({
    required this.body,
    required this.from,
    required this.sendDate,
    required this.to,
  });

  /// Deserializes a [json] Map into an instance of [Message].
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Parses this [Message] into a JSON Map.
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// The message body.
  @HiveField(0)
  final String body;

  /// The message author.
  @HiveField(1)
  final Contact from;

  /// The message receiver.
  @HiveField(2)
  final Contact to;

  /// The date this message has been sent at.
  @HiveField(3)
  final DateTime sendDate;

  @override
  List<Object?> get props => [body, from, to, sendDate];
}
