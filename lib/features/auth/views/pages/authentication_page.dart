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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Sign In To Get Started'),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: context.read<AuthCubit>().login,
                      label: const Text('Sign In With Google'),
                      icon: const Icon(Icons.chair),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
