import 'dart:async';

import 'package:xave/core/datasources/datasource_service.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/core/models/message.dart';
import 'package:xave/features/chat/logic/repository/chat_repository.dart';

/// An Implementation of [IChatRepository].
class ChatRepositoryImpl implements IChatRepository {
  /// Initializes a new [ChatRepositoryImpl]
  const ChatRepositoryImpl({
    required IDataSourceService<Map<String, dynamic>> remoteStorage,
    required IDataSourceService<Conversation> localStorage,
  })  : _local = localStorage,
        _remote = remoteStorage;

  final IDataSourceService<Map<String, dynamic>> _remote;
  final IDataSourceService<Conversation> _local;

  @override
  Future<List<Conversation>> fetchChats(Contact me) async {
    final chats = <Conversation>[];
    final localChats = await _local.readAll();
    if (localChats.isNotEmpty) {
      await _local.clean();
    }
    final data = await _remote.readAll();
    for (final doc in data) {
      chats.add(Conversation.fromJson(doc));
    }
    for (final c in chats) {
      await _local.write(c.uuid, c);
    }
    return chats
        .where((c) => c.contacts.map((c) => c.email).contains(me.email))
        .toList();
  }

  @override
  Future<List<Conversation>> getLocalChats() {
    return _local.readAll();
  }

  @override
  Future<void> pushChat(Conversation conversation) async {
    await _remote.write(conversation.uuid, conversation.toJson());
  }

  @override
  Future<void> addMessage(Conversation conversation, Message message) async {
    final messages = conversation.messages..add(message);
    final chat = conversation.copyWith(
      messages: messages,
      updatedAt: messages.last.sendDate,
    );
    await _remote.update(conversation.uuid, chat.toJson());
    await _local.update(conversation.uuid, chat);
  }

  @override
  Future<void> removeMessage(
    Conversation conversation,
    Message message,
  ) async {
    final messages = [...conversation.messages]..remove(message);
    final chat = conversation.copyWith(
      messages: messages,
      updatedAt: DateTime.now(),
    );
    await _remote.update(conversation.uuid, chat.toJson());
    await _local.update(conversation.uuid, chat);
  }

  @override
  Stream<Conversation?> get chatsQueue {
    final _controller = StreamController<Conversation>();
    _remote.dataStream.listen((event) {
      _controller.sink.add(Conversation.fromJson(event));
    });
    return _controller.stream;
  }
}
