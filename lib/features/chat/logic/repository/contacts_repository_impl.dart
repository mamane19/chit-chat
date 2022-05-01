import 'package:xave/core/datasources/datasource_service.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/features/chat/logic/repository/contacts_repository.dart';

/// An implementation of [IContactsRepository].
class ContactsRepositoryImpl implements IContactsRepository {
  /// Initializes a new [ContactsRepositoryImpl]
  const ContactsRepositoryImpl({
    required IDataSourceService<Contact> contactsStorage,
  }) : _storage = contactsStorage;
  final IDataSourceService<Contact> _storage;

  @override
  Future<List<Contact>> getContacts() {
    return _storage.readAll();
  }

  @override
  Future<void> addContact(Contact contact) async {
    await _storage.write(contact.email, contact);
  }
}
