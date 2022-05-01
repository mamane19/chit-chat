// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xave/core/models/contact.dart';

part 'account.g.dart';

/// A model that holds the account's data.
@JsonSerializable(fieldRename: FieldRename.kebab)
@HiveType(typeId: 2)
class Account extends Contact with EquatableMixin {
  /// Initializes a new [Account] object.
  const Account({
    required this.uuid,
    required this.email,
    required this.name,
    this.imageURL,
  }) : super(email: email, name: name, imageURL: imageURL);

  /// Deserializes a [json] Map into an instance of [Account].
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// The account's uniqur id.
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  @override
  final String email;

  @override
  @HiveField(2)
  final String name;

  @override
  @HiveField(3)
  final String? imageURL;

  /// Parses this [Account] object into a JSON Map.
  @override
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  /// Copies this [Account] and returns a new one with the passed parameters.
  ///
  /// The ignored fields will be copied from the current [Account] instance.
  Account copyWith({
    String? uuid,
    String? name,
    String? email,
    String? imageURL,
  }) =>
      Account(
        uuid: uuid ?? this.uuid,
        email: email ?? this.email,
        name: name ?? this.name,
      );

  @override
  List<Object?> get props => [email, name, imageURL, uuid];
}
