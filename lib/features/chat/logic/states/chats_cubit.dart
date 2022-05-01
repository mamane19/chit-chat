import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/core/models/message.dart';
import 'package:xave/features/chat/logic/repository/chat_repository.dart';

part 'chats_state.dart';

/// A [Cubit] that manages the state of chats.
class ChatsCubit extends Cubit<ChatsState> {
  /// Initializes a new [ChatsCubit].
  ChatsCubit({
    required IChatRepository repository,
    required this.loggedContact,
  })  : _repository = repository,
        super(ChatsInitial()) {
    var s = state;
    final chats = <Conversation>[];
    _repository.chatsQueue.listen((event) {
      if (s is ChatsLoaded) {
        chats.addAll((s as ChatsLoaded).chats);
        if (event != null && !chats.contains(event)) {
          chats.add(event);
          s = ChatsLoaded(chats: chats);
        }
      } else {
        if (event != null) {
          chats.add(event);
          s = ChatsLoaded(chats: chats);
          emit(s);
        }
      }
    });
    emit(s);
  }

  /// Conversations Queue
  Stream<Conversation?> get chatsQueue => _repository.chatsQueue;

  @override
  void emit(ChatsState state) {
    var s = state;
    if (state is ChatsLoaded) {
      final content = state.chats;
      _repository.chatsQueue.listen((event) {
        if (event != null && !content.contains(event)) {
          s = ChatsLoaded(chats: content);
        }
      });
    }
    super.emit(s);
  }

  final IChatRepository _repository;

  /// The currently logged account.
  Contact? loggedContact;

  bool _isClosed = false;

  /// Loads the chats.
  Future<void> load() async {
    emit(ChatsLoading());
    try {
      if (loggedContact == null) {
        throw Exception('User not logged');
      } else {
        final chats = await _repository.fetchChats(loggedContact!);
        if (!_isClosed) {
          emit(ChatsLoaded(chats: chats));
        }
      }
    } catch (e, s) {
      debugPrint('$e\n$s');
      emit(ChatsFailure(message: '$e'));
    }
  }

  /// Sends a [message] to the selected [conversation].
  Future<void> send({
    required Conversation conversation,
    required Message message,
  }) async {
    emit(ChatsLoading());
    try {
      await _repository.addMessage(conversation, message);
      var chats = <Conversation>[];
      if (loggedContact == null) {
        throw Exception('User not logged');
      } else {
        try {
          chats = await _repository.fetchChats(loggedContact!);
        } on Exception {
          chats = await _repository.getLocalChats();
        }
      }

      emit(ChatsLoaded(chats: chats));
    } catch (e, s) {
      debugPrint('$e\n$s');
      emit(ChatsFailure(message: '$e'));
    }
  }

  /// Deletes a [message] from the [conversation].
  Future<void> deleteMessage({
    required Conversation conversation,
    required Message message,
  }) async {
    emit(ChatsLoading());
    try {
      await _repository.addMessage(conversation, message);
      if (loggedContact == null) {
        throw Exception('User not logged');
      } else {
        final chats = await _repository.fetchChats(loggedContact!);
        emit(ChatsLoaded(chats: chats));
      }
    } catch (e, s) {
      debugPrint('$e\n$s');
      emit(ChatsFailure(message: '$e'));
    }
  }

  @override
  Future<void> close() async {
    await super.close();
    _isClosed = true;
  }
}
