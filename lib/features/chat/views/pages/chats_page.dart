import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/features/auth/logic/states/auth_cubit.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/views/pages/conversation_page.dart';
import 'package:xave/features/chat/views/pages/new_chat_page.dart';

/// A page with all the conversations.
class ChatsPage extends StatelessWidget {
  /// Initializes a new [ChatsPage].
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          void _navigate(Conversation chat) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => Builder(
                  builder: (context) {
                    return ConversationPage(conversation: chat);
                  },
                ),
              ),
            );
          }

          showModalBottomSheet<void>(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => NewChatPage(onStarted: _navigate),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('Chats'),
            pinned: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
          ),
          BlocBuilder<ChatsCubit, ChatsState>(
            builder: (context, state) {
              if (state is ChatsLoaded) {
                if (state.chats.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('No Chat...Yet')),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final chat = state.chats[i];
                      final lastMessage = chat.messages.last;
                      final authState =
                          context.read<AuthCubit>().state as AuthLoggedIn;
                      final receiver = chat.contacts.firstWhere(
                        (c) => c.email != authState.account.email,
                      );
                      return ListTile(
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (context) => ConversationPage(
                              conversation: chat,
                            ),
                          ),
                        ),
                        title: Text(receiver.name ?? receiver.email),
                        subtitle: Text(
                          lastMessage.body,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      );
                    },
                    childCount: state.chats.length,
                  ),
                );
              }
              return const SliverToBoxAdapter();
            },
          ),
        ],
      ),
    );
  }
}
