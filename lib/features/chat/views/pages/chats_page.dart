import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/features/auth/logic/states/auth_cubit.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/views/pages/conversation_page.dart';
import 'package:xave/features/chat/views/pages/new_chat_page.dart';
import 'package:xave/features/chat/views/pages/profile_page.dart';

/// A page with all the conversations.
class ChatsPage extends StatelessWidget {
  /// Initializes a new [ChatsPage].
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.person),
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: context.read<AuthCubit>().logout,
            icon: const Icon(EvaIcons.logOut),
          ),
        ],
      ),
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
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text('No Chat...Yet'));
            }
            return SmartRefresher(
              controller: RefreshController(initialLoadStatus: LoadStatus.idle),
              header: WaterDropMaterialHeader(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onRefresh: context.read<ChatsCubit>().load,
              child: ListView.separated(
                itemBuilder: (context, i) {
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
                separatorBuilder: (context, _) => const Divider(),
                itemCount: state.chats.length,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
