import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/network/network_service.dart';
import '../theme/app_colors.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        
        // Force uncollapse if we switch to mobile so the drawer opens properly
        final bool effectivelyCollapsed = isDesktop && _isSidebarCollapsed;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          appBar: isDesktop
              ? null // No AppBar on desktop
              : AppBar(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  title: Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 32),
                      const SizedBox(width: 8),
                      const Text('SASHECO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
          drawer: isDesktop ? null : Drawer(child: _buildSidebar(context, isMobile: true, isCollapsed: false)),
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context, isMobile: false, isCollapsed: effectivelyCollapsed),
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isMobile, required bool isCollapsed}) {
    final double sidebarWidth = isCollapsed ? 80 : 250;

    final authState = context.watch<AuthCubit>().state;
    String? roleId;
    if (authState is AuthSuccess) {
      roleId = authState.user.roleId;
    }

    final isAdmin = roleId == '11111111-1111-1111-1111-111111111111' || roleId == null || roleId.isEmpty;
    final isProjectManager = roleId == '11111111-1111-1111-1111-111111111112';
    final isFinance = roleId == '11111111-1111-1111-1111-111111111113';
    final isAuditor = roleId == '11111111-1111-1111-1111-111111111114';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      color: AppColors.primary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: isCollapsed ? 32 : 40),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SASHECO',
                            style: TextStyle(
                              color: AppColors.surface,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Enterprise Hub',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isMobile && !isCollapsed) ...[
                       const Spacer(),
                       IconButton(
                         icon: const Icon(Icons.close, color: Colors.white70),
                         onPressed: () => Navigator.pop(context), // Close Drawer
                       ),
                       const SizedBox(width: 8),
                    ]
                  ],
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 16),
                    children: [
                      _buildNavItem(context, 'dashboard'.tr(), Icons.dashboard_outlined, '/dashboard', isCollapsed),
                      if (isAdmin || isProjectManager)
                        _buildNavItem(context, 'users_review'.tr(), Icons.people_alt_outlined, '/user-review', isCollapsed),
                      if (isAdmin || isProjectManager)
                        _buildNavItem(context, 'engineering'.tr(), Icons.engineering_outlined, '/engineering', isCollapsed),
                      if (isAdmin)
                        _buildNavItem(context, 'secretary'.tr(), Icons.description_outlined, '/secretary', isCollapsed),
                      if (isAdmin || isFinance || isAuditor)
                        _buildNavItem(context, 'financial'.tr(), Icons.account_balance_wallet_outlined, '/financial', isCollapsed),
                      if (isAdmin || isAuditor)
                        _buildNavItem(context, 'approval'.tr(), Icons.fact_check_outlined, '/approval', isCollapsed),
                      if (isAdmin || isFinance)
                        _buildNavItem(context, 'vendor'.tr(), Icons.storefront_outlined, '/vendor', isCollapsed),
                      if (isAdmin || isProjectManager)
                        _buildNavItem(context, 'site'.tr(), Icons.location_city_outlined, '/site', isCollapsed),
                      if (isAdmin)
                        _buildNavItem(context, 'setting'.tr(), Icons.settings_outlined, '/global-permissions', isCollapsed),
                    ],
                  ),
                ),
                // Language Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      if (!isCollapsed)
                        const Icon(Icons.language, color: Colors.white, size: 20),
                      if (!isCollapsed)
                        const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // VERY visible
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (context.locale.languageCode == 'en') {
                            context.setLocale(const Locale('ar'));
                            NetworkService.currentLanguage = 'ar';
                          } else {
                            context.setLocale(const Locale('en'));
                            NetworkService.currentLanguage = 'en';
                          }
                        },
                        child: Text(
                          context.locale.languageCode == 'en' ? 'العربية' : 'English',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                // Profile area at bottom
                Padding(
                  padding: EdgeInsets.all(isCollapsed ? 8.0 : 16.0),
                  child: Container(
                    padding: EdgeInsets.all(isCollapsed ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.accent,
                          radius: 18,
                          child: Icon(Icons.person, color: AppColors.primary, size: 20),
                        ),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(authState is AuthSuccess ? authState.user.name : 'User', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(authState is AuthSuccess ? authState.user.email : '', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Collapse Toggle Button on Desktop
          if (!isMobile)
            Positioned(
              right: -14,
              top: 40,
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String path, bool isCollapsed) {
    final location = GoRouterState.of(context).uri.path;
    final isSelected = location.startsWith(path);

    Widget navContent = Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: isCollapsed ? const EdgeInsets.symmetric(horizontal: 8) : const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.white70,
        ),
        title: isCollapsed
            ? null
            : Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          context.go(path);
          // Auto close drawer on mobile navigation
          if (MediaQuery.of(context).size.width < 900) {
            Navigator.pop(context);
          }
        },
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: title,
        preferBelow: false,
        child: navContent,
      );
    }
    return navContent;
  }
}
