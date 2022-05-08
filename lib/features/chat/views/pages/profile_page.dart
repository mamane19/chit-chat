import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/cubit/brightness_cubit.dart';
import 'package:xave/features/auth/auth.dart';
import 'package:xave/features/auth/views/pages/authentication_page.dart';

/// The page with the user's profile.
class ProfilePage extends StatelessWidget {
  /// Initializes a new [ProfilePage].
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.of(context)
            ..popUntil((route) => route.isFirst)
            ..pushReplacement(
              MaterialPageRoute<void>(
                builder: ((context) => const AuthenticationPage()),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          final user = state.account;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        if (user.imageURL != null)
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: CachedNetworkImageProvider(
                              user.imageURL!,
                            ),
                          )
                        else
                          const CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.grey,
                            child: Icon(EvaIcons.person),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Brightness'),
                            SizedBox(
                              width: 96,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    EvaIcons.moon,
                                    size: 16,
                                    color: Colors.blueGrey,
                                  ),
                                  BlocBuilder<BrightnessCubit, Brightness>(
                                    builder: (context, brightness) {
                                      return Switch(
                                        value: brightness == Brightness.light,
                                        onChanged: (_) => context
                                            .read<BrightnessCubit>()
                                            .toggle(),
                                      );
                                    },
                                  ),
                                  const Icon(
                                    Icons.sunny,
                                    size: 16,
                                    color: Colors.blueGrey,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: context.read<AuthCubit>().logout,
                    child: const Text('Sign Out'),
                  )
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
