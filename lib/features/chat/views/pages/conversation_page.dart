import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/core/models/message.dart';
import 'package:xave/features/auth/logic/states/auth_cubit.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/logic/states/contacts_cubit.dart';
import 'package:xave/features/chat/views/widgets/message_input_bar.dart';

/// Page that renders messages of a given [conversation] and a space to write
/// message.
class ConversationPage extends StatelessWidget {
  /// Initializes a new [Conversation].
  const ConversationPage({required this.conversation, Key? key})
      : super(key: key);

  /// The conversation whose data is being displayed in this page.
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoggedIn) {
          final contact = conversation.contacts.firstWhere(
            (c) => c.email != authState.account.email,
          );
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(contact.name ?? contact.email),
            ),
            body: BlocBuilder<ChatsCubit, ChatsState>(
              bloc: context.read<ChatsCubit>(),
              builder: (context, state) {
                var currentChat = conversation;
                if (state is ChatsLoaded) {
                  currentChat = state.chats.firstWhere(
                    (c) => c.uuid == conversation.uuid,
                  );
                }
                final messages = currentChat.messages;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: messages.map(
                            (m) {
                              final isMyMessage =
                                  m.from.email == authState.account.email;
                              return Row(
                                key: ValueKey<int>(messages.indexOf(m)),
                                mainAxisAlignment: isMyMessage
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: <Widget>[
                                  MessageBubble(
                                    isMyMessage: isMyMessage,
                                    message: m,
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    MessageInputBar(
                      conversation: conversation,
                      onSend: (text) {
                        final message = Message(
                          body: text,
                          from: authState.account,
                          to: contact,
                          sendDate: DateTime.now(),
                        );
                        context.read<ChatsCubit>().send(
                              conversation: conversation,
                              message: message,
                            );
                        context.read<ContactsCubit>().add(message.to);
                      },
                    )
                  ],
                );
              },
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}

///
class MessageBubble extends StatelessWidget {
  ///
  const MessageBubble({
    Key? key,
    required this.isMyMessage,
    required this.message,
  }) : super(key: key);

  /// whether or not the current user is the author of this message.
  final bool isMyMessage;

  /// The message.
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - kMinInteractiveDimension,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMyMessage
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        message.body,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
