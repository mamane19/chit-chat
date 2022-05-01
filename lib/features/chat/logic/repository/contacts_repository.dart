import 'package:xave/core/models/contact.dart';

/// An interface for the contact repository.
abstract class IContactsRepository {
  /// Gets contacts from a data source.
  Future<List<Contact>> getContacts();

  /// Saves a new contact.
  Future<void> addContact(Contact contact);
}
