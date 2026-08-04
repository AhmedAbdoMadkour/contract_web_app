import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/screens/login_screen.dart';
import 'package:sasheco_dashboard_web/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/screens/create_user_screen.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/screens/global_permissions_screen.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/screens/engineering_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/screens/create_engineering_project_screen.dart';
import 'package:sasheco_dashboard_web/features/secretary/presentation/screens/secretary_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/screens/financial_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/approval/presentation/screens/approval_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/site/presentation/screens/site_dashboard_screen.dart';
import 'package:sasheco_dashboard_web/features/site/presentation/screens/site_mapping_screen.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/screens/user_review_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sasheco_dashboard_web/core/router/go_router_refresh_stream.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sasheco_dashboard_web/core/layout/app_layout.dart';
import 'package:sasheco_dashboard_web/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_cubit.dart';
import 'package:sasheco_dashboard_web/features/secretary/presentation/cubit/secretary_cubit.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/cubit/finance_cubit.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/features/site/presentation/cubit/site_cubit.dart';
import 'package:sasheco_dashboard_web/features/contracts/presentation/screens/contracts_screen.dart';
import 'package:sasheco_dashboard_web/features/contracts/presentation/cubit/contracts_cubit.dart';

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
        builder: (context, state) => LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<DashboardCubit>().loadDashboardMetrics();
              });
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: '/contracts',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ContractsCubit>().loadContracts();
              });
              return const ContractsScreen();
            },
          ),
          GoRoute(
            path: '/create-user',
            builder: (context, state) => const CreateUserScreen(),
          ),
          GoRoute(
            path: '/user-review',
            builder: (context, state) => const UserReviewScreen(),
          ),
          GoRoute(
            path: '/global-permissions',
            builder: (context, state) => const GlobalPermissionsScreen(),
          ),
          GoRoute(
            path: '/engineering',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<EngineeringCubit>().fetchProjects();
              });
              return const EngineeringDashboardScreen();
            },
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateEngineeringProjectScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/secretary',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<SecretaryCubit>().fetchInbox();
                context.read<SecretaryCubit>().fetchTasks();
              });
              return const SecretaryDashboardScreen();
            },
          ),
          GoRoute(
            path: '/financial',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<FinanceCubit>().fetchDashboardData();
              });
              return const FinancialDashboardScreen();
            },
          ),
          GoRoute(
            path: '/approval',
            builder: (context, state) => const ApprovalDashboardScreen(),
          ),
          GoRoute(
            path: '/vendor',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<VendorCubit>().getVendors();
              });
              return const VendorDashboardScreen();
            },
          ),
          GoRoute(
            path: '/site',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<SiteCubit>().fetchSiteDashboard();
              });
              return const SiteDashboardScreen();
            },
            routes: [
              GoRoute(
                path: 'mapping',
                builder: (context, state) => const SiteMappingScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
