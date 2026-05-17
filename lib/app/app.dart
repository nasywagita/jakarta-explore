import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class JakartaExploreApp extends StatelessWidget {
  const JakartaExploreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JakartaExplore',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
