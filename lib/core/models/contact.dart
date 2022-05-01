import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

/// A model that holds data of a chat contact.
@HiveType(typeId: 3)
@JsonSerializable(fieldRename: FieldRename.kebab)
class Contact with EquatableMixin {
  /// Initializes a new [Contact].
  const Contact({required this.email, this.imageURL, this.name});

  /// Parses a [json] Map into an instance of [Contact].
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  /// Parses this instance of [Contact] into a json Map.
  Map<String, dynamic> toJson() => _$ContactToJson(this);

  /// This contact's email address.
  @HiveField(0)
  final String email;

  /// This contact's name.
  @HiveField(1)
  final String? name;

  /// Profile picture
  @HiveField(2)
  final String? imageURL;

  @override
  List<Object?> get props => [email, name, imageURL];
}
