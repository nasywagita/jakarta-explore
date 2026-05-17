import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'data/local/auth_local.dart';
import 'data/repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import 'data/repositories/destinations_repository.dart';
import 'providers/destinations_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Dukungan untuk Web dan Desktop (Windows/Linux/macOS)
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Setup Dependencies
  final authLocal = AuthLocal();
  final authRepository = AuthRepository(authLocal);
  final destinationsRepository = DestinationsRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),

        ChangeNotifierProvider(
          create: (_) =>
              DestinationsProvider(repository: destinationsRepository)
                ..fetchDestinations(),
        ),

        ChangeNotifierProxyProvider<AuthProvider, BookmarkProvider>(
          create: (_) => BookmarkProvider(),
          update: (_, auth, bookmark) =>
              bookmark!..updateUserId(auth.user?.id),
        ),

        ChangeNotifierProxyProvider<AuthProvider, QuizProvider>(
          create: (_) => QuizProvider(),
          update: (_, auth, quiz) =>
              quiz!..updateUserId(auth.user?.id),
        ),

        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const JakartaExploreApp(),
    ),
  );
}