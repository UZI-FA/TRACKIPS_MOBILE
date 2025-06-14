import 'package:go_router/go_router.dart';
import 'provider/auth_provider.dart';
import 'pages/login/login_page.dart';
import 'pages/login/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/tracker_page.dart';

GoRouter Routing(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? '/map' : '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final loggedIn = authProvider.isAuthenticated;
        // if (loggedIn) authProvider.tryAutoLogin();
        
        final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!loggedIn && !loggingIn) return '/login';
        if (loggedIn && loggingIn) return '/map';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => DashboardPage(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => Tracker(),
        ),
      ],
    );
  }