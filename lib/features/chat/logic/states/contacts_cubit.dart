import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/features/chat/logic/repository/contacts_repository.dart';

part 'contacts_state.dart';

/// A [Cubit] that manages the states and business logic of contacts
class ContactsCubit extends Cubit<ContactsState> {
  /// Initializes a new [ContactsCubit].
  ContactsCubit({required IContactsRepository repository})
      : _repository = repository,
        super(ContactsInitial());

  final IContactsRepository _repository;

  /// Loads the contacts and emits a [ContactsLoaded].
  ///
  /// In case of error, a [ContactsFailure] state will be emitted instead.
  Future<void> load() async {
    emit(ContactsLoading());
    try {
      final contacts = await _repository.getContacts();
      emit(ContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactsFailure(message: '$e'));
    }
  }

  /// Saves a new [contact] and fetches the updated list of contacts before
  /// emitting them in a [ContactsLoaded].
  ///
  /// In case of an error, a [ContactsFailure] state wil be emitted instead.
  Future<void> add(Contact contact) async {
    emit(ContactsLoading());
    try {
      await _repository.addContact(contact);
      final contacts = await _repository.getContacts();
      emit(ContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactsFailure(message: '$e'));
    }
  }
}
