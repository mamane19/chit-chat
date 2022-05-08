import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/features/auth/logic/states/auth_cubit.dart';
import 'package:xave/features/chat/logic/repository/chat_repository.dart';
import 'package:xave/features/chat/logic/states/chats_cubit.dart';
import 'package:xave/features/chat/views/pages/chats_page.dart';

/// Authentication page.
class AuthenticationPage extends StatelessWidget {
  /// Initializes a new [AuthenticationPage].
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.message ?? 'failed to login'),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                )
              ],
            ),
          );
        } else if (state is AuthLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (context) => BlocProvider(
                create: (context) => ChatsCubit(
                  repository: context.read<IChatRepository>(),
                  loggedContact: state.account,
                )..load(),
                child: const ChatsPage(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chit Chat',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'A unique chatting experience',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: context.read<AuthCubit>().login,
                label: const Text('Sign In With Google'),
                icon: const Icon(EvaIcons.google),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
