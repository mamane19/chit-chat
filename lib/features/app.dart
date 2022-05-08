import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/cubit/brightness_cubit.dart';
import 'package:xave/features/auth/auth.dart';
import 'package:xave/features/auth/views/pages/authentication_page.dart';
import 'package:xave/features/chat/logic/repository/chat_repository.dart';
import 'package:xave/features/chat/logic/repository/contacts_repository.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/logic/states/contacts_cubit.dart';
import 'package:xave/features/chat/views/pages/chats_page.dart';

/// Widget tree's entreypoint.
class App extends StatelessWidget {
  /// Initializes a new [App].
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<IAuthRepository>();
    final contactsRepo = context.read<IContactsRepository>();
    final chatsRepo = context.read<IChatRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(repository: authRepo)),
        BlocProvider(
          create: (context) => ContactsCubit(repository: contactsRepo)..load(),
        ),
        BlocProvider(
          create: (context) => ChatsCubit(
            repository: chatsRepo,
            loggedContact: null,
          ),
        ),
        BlocProvider(create: (context) => BrightnessCubit()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrightnessCubit, Brightness>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: state,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: state,
            ),
          ),
          home: Builder(
            builder: (context) {
              return BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  final chatsCubit = context.read<ChatsCubit>();
                  if (state is AuthLoggedIn) {
                    chatsCubit
                      ..loggedContact = state.account
                      ..load();
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoggedIn) {
                    return const ChatsPage();
                  } else if (state is AuthLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const AuthenticationPage();
                },
              );
            },
          ),
        );
      },
    );
  }
}
