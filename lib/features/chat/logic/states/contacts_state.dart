part of 'contacts_cubit.dart';

/// Base state that can be emitted by [ContactsCubit].
abstract class ContactsState extends Equatable {
  /// Initializes a new [ContactsState].
  const ContactsState();

  @override
  List<Object?> get props => [];
}

/// Initia state.
class ContactsInitial extends ContactsState {}

/// State emitted when the contacts are loading.
class ContactsLoading extends ContactsState {}

/// State emitted when the contacts are loaded.
class ContactsLoaded extends ContactsState {
  /// Initializes a new [ContactsLoaded]
  const ContactsLoaded({required this.contacts});

  /// The available contacts.
  final List<Contact> contacts;
  @override
  List<Object> get props => [...contacts];
}

/// State emitted when an error ooccured.
class ContactsFailure extends ContactsState {
  /// Initializes a new [ContactsFailure].
  const ContactsFailure({this.message});

  /// The error message.
  final String? message;

  @override
  List<Object?> get props => [message];
}
