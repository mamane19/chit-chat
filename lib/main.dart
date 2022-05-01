import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xave/core/configs/hive_configs.dart';
import 'package:xave/core/datasources/firestore_service.dart';
import 'package:xave/core/datasources/hive_service.dart';
import 'package:xave/features/app.dart';
import 'package:xave/features/auth/auth.dart';
import 'package:xave/features/chat/logic/repository/chat_repository.dart';
import 'package:xave/features/chat/logic/repository/chat_repository_impl.dart';
import 'package:xave/features/chat/logic/repository/contacts_repository.dart';
import 'package:xave/features/chat/logic/repository/contacts_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveConfig.setup();

  final IChatRepository chatRepository = ChatRepositoryImpl(
    remoteStorage: FirestoreService(
      collectionPath: 'chats',
      firestore: FirebaseFirestore.instance,
    ),
    localStorage: HiveService(box: HiveConfig.chatsBox),
  );

  final IContactsRepository contactsRepository = ContactsRepositoryImpl(
    contactsStorage: HiveService(box: HiveConfig.contactsBox),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthRepository>(
          create: (context) => FirebaseAuthRepository(),
        ),
        RepositoryProvider.value(value: chatRepository),
        RepositoryProvider.value(value: contactsRepository)
      ],
      child: const App(),
    ),
  );
}
