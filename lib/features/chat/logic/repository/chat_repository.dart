import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/core/models/message.dart';

/// An interface the chat repository that handles querying and pushing chats
/// to the data sources.
abstract class IChatRepository {
  /// Fetches conversations from the remote storage.
  Future<List<Conversation>> fetchChats(Contact me);

  /// Gets chats from the local storage.
  Future<List<Conversation>> getLocalChats();

  /// Saves a [conversation] to the remote storage.
  Future<void> pushChat(Conversation conversation);

  /// Adds a message to a [conversation].
  Future<void> addMessage(Conversation conversation, Message message);

  /// Removes a message from a [conversation].
  Future<void> removeMessage(Conversation conversation, Message message);

  /// Real-time chats queue.
  Stream<Conversation?> get chatsQueue;
}
