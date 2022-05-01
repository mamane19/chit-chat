import 'package:hive_flutter/adapters.dart';
import 'package:xave/core/models/account.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/core/models/message.dart';

/// Utiity class that handes [Hive] setups and initializations.
class HiveConfig {
  HiveConfig._();

  /// Registers all the required hive adapters.
  static void _registerAdapters() {
    Hive
      ..registerAdapter(MessageAdapter())
      ..registerAdapter(ConversationAdapter())
      ..registerAdapter(ContactAdapter())
      ..registerAdapter(AccountAdapter());
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<Conversation>('chats');
    await Hive.openBox<Contact>('contacts');
  }

  /// A Hive box that holds chat data.
  static Box<Conversation> get chatsBox => Hive.box<Conversation>('chats');

  /// A Hive box that holds contacts.
  static Box<Contact> get contactsBox => Hive.box<Contact>('contacts');

  /// Sets hive up.
  static Future<void> setup() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  /// Closes all the opened hive boxes.
  Future<void> close() => Hive.close();
}
