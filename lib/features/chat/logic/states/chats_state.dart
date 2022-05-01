part of 'chats_cubit.dart';

/// Base state type.
abstract class ChatsState extends Equatable {
  /// Initialilzes a new [ChatsState].
  const ChatsState();

  @override
  List<Object> get props => [];
}

/// Initial state.
class ChatsInitial extends ChatsState {}

/// State emitted when an operation is running.
class ChatsLoading extends ChatsState {}

/// State emitted when chats are loaded.
class ChatsLoaded extends ChatsState {
  /// Initializes a new [ChatsLoaded].
  const ChatsLoaded({required this.chats});

  /// The loaded chats.
  final List<Conversation> chats;

  @override
  List<Object> get props => [...chats];
}

/// State emitted when an exceptio occured.
class ChatsFailure extends ChatsState {
  /// Initializes a new [ChatsFailure]
  const ChatsFailure({this.message});

  /// Error message.
  final String? message;
}
