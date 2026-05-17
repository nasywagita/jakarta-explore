import 'package:go_router/go_router.dart';
import '../splash_screen.dart';
import '../onboarding_screen.dart';
import '../login_screen.dart';
import '../register_screen.dart';
import '../main_wrapper.dart';
import '../wisata_detail_screen.dart';
import '../quiz_play_screen.dart';
import '../leaderboard_screen.dart';
import '../data/models/destination_model.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const MainWrapper()),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final destination = state.extra as DestinationModel;
        return WisataDetailScreen(destination: destination);
      },
    ),
    GoRoute(
      path: '/quiz-play',
      builder: (context, state) => const QuizPlayScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const LeaderboardScreen(),
    ),
  ],
);
