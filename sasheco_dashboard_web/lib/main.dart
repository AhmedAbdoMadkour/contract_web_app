import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sasheco_dashboard_web/core/router/app_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_theme.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sasheco_dashboard_web/core/shared/network/network_service.dart';
import 'package:sasheco_dashboard_web/features/auth/data/repository/auth_repository.dart';
import 'package:sasheco_dashboard_web/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sasheco_dashboard_web/features/dashboard/data/repository/dashboard_repository.dart';
import 'package:sasheco_dashboard_web/features/user_management/presentation/cubit/user_management_cubit.dart';
import 'package:sasheco_dashboard_web/features/user_management/data/repository/user_management_repository.dart';
import 'package:sasheco_dashboard_web/features/finance/presentation/cubit/finance_cubit.dart';
import 'package:sasheco_dashboard_web/features/finance/data/repository/finance_repository_impl.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/data/repository/engineering_repository.dart';
import 'package:sasheco_dashboard_web/features/site/presentation/cubit/site_cubit.dart';
import 'package:sasheco_dashboard_web/features/site/data/repository/site_repository.dart';
import 'package:sasheco_dashboard_web/core/localization/locale_cubit.dart';
import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:sasheco_dashboard_web/features/vendor/data/repository/vendor_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NetworkService networkService;
  late final AuthCubit authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    networkService = NetworkService();
    authCubit = AuthCubit(AuthRepository(networkService));
    _router = createAppRouter(authCubit);
  }

  @override
  void dispose() {
    authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: authCubit,
        ),
        BlocProvider(
          create: (context) => LocaleCubit(widget.prefs),
        ),
        BlocProvider(
          create: (context) => DashboardCubit(
            DashboardRepository(networkService),
          ),
        ),
        BlocProvider(
          create: (context) => UserManagementCubit(
            UserManagementRepositoryImpl(networkService),
          ),
        ),
        BlocProvider(
          create: (context) => FinanceCubit(
            FinanceRepositoryImpl(networkService),
          ),
        ),
        BlocProvider(
          create: (context) => EngineeringCubit(
            EngineeringRepository(networkService),
          ),
        ),
        BlocProvider(
          create: (context) => SiteCubit(
            repository: SiteRepositoryImpl(networkService: networkService),
          ),
        ),
        BlocProvider(
          create: (context) => VendorCubit(
            VendorRepository(networkService),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'SASHECO Dashboard',
            theme: AppTheme.lightTheme,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
          );
        },
      ),
    );
  }
}
