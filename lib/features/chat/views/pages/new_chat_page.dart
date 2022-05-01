import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/models/contact.dart';
import 'package:xave/core/models/conversation.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/logic/states/contacts_cubit.dart';

/// Page where the user can start a new [Conversation].
class NewChatPage extends StatefulWidget {
  /// Initializes a new [NewChatPage].
  const NewChatPage({required this.onStarted, Key? key}) : super(key: key);

  /// Callback for when the user presses the start conversation button.
  final void Function(Conversation) onStarted;

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late final _controller = TextEditingController();
  late final _contactFilterNotifier = ValueNotifier<List<Contact>>([]);
  bool isValidEmail = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoaded) {
          final cubit = context.read<ChatsCubit>();
          _contactFilterNotifier.value = state.contacts;

          return Container(
            margin: const EdgeInsets.only(top: 64),
            padding: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('New Chat'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter contact email',
                      label: Text('Contact'),
                    ),
                    onChanged: (text) {
                      final all = _contactFilterNotifier.value;
                      _contactFilterNotifier.value = _filter(text, all);
                      setState(() {
                        isValidEmail = text.isValidEmail;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ChatsCubit, ChatsState>(
                    builder: (context, chatsState) {
                      if (chatsState is ChatsLoaded) {
                        return ElevatedButton(
                          onPressed: !isValidEmail
                              ? null
                              : () {
                                  late Conversation conversation;
                                  final mails = <String>[];
                                  for (final c in chatsState.chats) {
                                    for (final a in c.contacts) {
                                      mails.add(a.email);
                                    }
                                  }

                                  final contact = Contact(
                                    email: _controller.text.trim(),
                                  );
                                  if (mails.contains(contact.email)) {
                                    conversation = chatsState.chats.firstWhere(
                                      (e) => e.contacts
                                          .map((z) => z.email)
                                          .contains(contact.email),
                                    );
                                  } else {
                                    conversation = Conversation(
                                      starter: cubit.loggedContact!,
                                      messages: [],
                                      uuid: _generateID(),
                                      updatedAt: DateTime.now(),
                                      contact: contact,
                                    );
                                  }

                                  Navigator.pop(context);
                                  widget.onStarted(conversation);
                                },
                          child: const Text('New Conversation'),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<Contact>>(
                      valueListenable: _contactFilterNotifier,
                      builder: (context, contacts, _) => Column(
                        children: contacts
                            .map(
                              (c) => ListTile(
                                onTap: () {
                                  _controller.value = TextEditingValue(
                                    text: c.email,
                                  );
                                  setState(() {
                                    isValidEmail =
                                        _controller.text.isValidEmail;
                                  });
                                },
                                key: ValueKey<String>(c.email),
                                title: Text(c.name ?? c.email),
                                subtitle: c.name != null ? Text(c.email) : null,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _generateID() {
    final a = context.read<ChatsCubit>().loggedContact;
    return a!.email + DateTime.now().toIso8601String();
  }

  List<Contact> _filter(String input, List<Contact> all) {
    return [
      ...all.where((c) => c.email.toLowerCase().contains(input.toLowerCase()))
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _contactFilterNotifier.dispose();
    super.dispose();
  }
}

extension on String {
  /// Validtes an email address.
  bool get isValidEmail {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }
}
