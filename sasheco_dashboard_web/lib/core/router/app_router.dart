import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/screens/login_screen.dart';
import 'package:sasheco_dashboard_web/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/screens/create_user_screen.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/screens/global_permissions_screen.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/screens/engineering_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/secretary/presentation/screens/secretary_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/screens/financial_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/approval/presentation/screens/approval_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/site/presentation/screens/site_dashboard_screen.dart';

import 'package:sasheco_dashboard_web/core/router/go_router_refresh_stream.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sasheco_dashboard_web/core/layout/app_layout.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is AuthSuccess;
      final isLoginRoute = state.uri.path == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/create-user',
            builder: (context, state) => const CreateUserScreen(),
          ),
          GoRoute(
            path: '/global-permissions',
            builder: (context, state) => const GlobalPermissionsScreen(),
          ),
          GoRoute(
            path: '/engineering',
            builder: (context, state) => const EngineeringDashboardScreen(),
          ),
          GoRoute(
            path: '/secretary',
            builder: (context, state) => const SecretaryDashboardScreen(),
          ),
          GoRoute(
            path: '/financial',
            builder: (context, state) => const FinancialDashboardScreen(),
          ),
          GoRoute(
            path: '/approval',
            builder: (context, state) => const ApprovalDashboardScreen(),
          ),
          GoRoute(
            path: '/vendor',
            builder: (context, state) => const VendorDashboardScreen(),
          ),
          GoRoute(
            path: '/site',
            builder: (context, state) => const SiteDashboardScreen(),
          ),
        ],
      ),
    ],
  );
}
