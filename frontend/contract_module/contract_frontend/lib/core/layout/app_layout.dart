import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/network/network_service.dart';
import '../theme/app_colors.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

class NavItemData {
  final String title;
  final IconData icon;
  final String path;
  NavItemData(this.title, this.icon, this.path);
}

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
          drawer: isDesktop
              ? null
              : Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildSidebar(context, isMobile: true, isCollapsed: false),
                    ),
                  ),
                ),
          body: Stack(
            children: [
              // Main content extends full width and height BEHIND the sidebar
              Container(
                margin: EdgeInsets.only(left: isDesktop ? (effectivelyCollapsed ? 84 : 280) : 0),
                width: double.infinity,
                height: double.infinity,
                color: AppColors.background,
                child: widget.child,
              ),
              // Floating Sidebar
              if (isDesktop)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _buildSidebar(context, isMobile: false, isCollapsed: effectivelyCollapsed),
                ),
                // Collapse Toggle Button on Desktop
                if (isDesktop)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    left: effectivelyCollapsed ? 84 : 280,
                    top: 72,
                    child: GestureDetector(
                      onTap: _toggleSidebar,
                      child: Container(
                        width: 24,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2130),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border(
                            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                            right: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                            bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(2, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          effectivelyCollapsed ? Icons.chevron_right : Icons.chevron_left,
                          size: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                // Global Exit Module Button (Routes to App Launcher)
                Positioned(
                  top: 24,
                  right: 32,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.go('/apps'),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isMobile, required bool isCollapsed}) {
    final double sidebarWidth = isCollapsed ? 84 : 280;

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2130).withOpacity(0.75), // Dark semi-transparent
              borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Glassy blur
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
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
                                    color: Colors.white,
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
                               onPressed: () => Navigator.pop(context),
                             ),
                             const SizedBox(width: 8),
                          ]
                        ],
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 16),
                          children: [
                            _buildNavItem(context, 'Dashboard', Icons.dashboard_outlined, '/dashboard', isCollapsed),
                            _buildNavGroup(
                              context,
                              'Contracts',
                              Icons.assignment_outlined,
                              [
                                NavItemData('View Contracts', Icons.list_alt_outlined, '/contracts'),
                                NavItemData('Templates', Icons.file_copy_outlined, '/contract-templates'),
                              ],
                              isCollapsed,
                            ),
                            if (isAdmin || isProjectManager)
                              _buildNavGroup(
                                context,
                                'Users',
                                Icons.group_outlined,
                                [
                                  if (isAdmin || isProjectManager)
                                    NavItemData('Review', Icons.people_alt_outlined, '/user-review'),
                                  if (isAdmin) NavItemData('Create', Icons.person_add_outlined, '/create-user'),
                                  if (isAdmin) NavItemData('Auth', Icons.admin_panel_settings_outlined, '/global-permissions'),
                                ],
                                isCollapsed,
                              ),
                              
                            if (isAdmin || isProjectManager || isFinance || isAuditor)
                              _buildNavGroup(
                                context,
                                'Departments',
                                Icons.domain_outlined,
                                [
                                  if (isAdmin || isProjectManager)
                                    NavItemData('Engineering', Icons.engineering_outlined, '/engineering'),
                                  if (isAdmin) NavItemData('Secretary', Icons.description_outlined, '/secretary'),
                                  if (isAdmin || isFinance || isAuditor)
                                    NavItemData('Financial', Icons.account_balance_wallet_outlined, '/financial'),
                                  if (isAdmin || isAuditor) NavItemData('Approval', Icons.fact_check_outlined, '/approval'),
                                ],
                                isCollapsed,
                              ),
                              
                            if (isAdmin || isFinance)
                              _buildNavItem(context, 'Vendor', Icons.storefront_outlined, '/vendor', isCollapsed),
                            
                            // Site Grouping
                            if (isAdmin || isProjectManager)
                              _buildNavGroup(
                                context,
                                'Site',
                                Icons.location_city_outlined,
                                [
                                  NavItemData('Dashboard', Icons.dashboard_outlined, '/site'),
                                  NavItemData('Site Mapping', Icons.map_outlined, '/site/mapping'),
                                ],
                                isCollapsed,
                              ),
                          ],
                        ),
                      ),
                      // Language Toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: isCollapsed
                            ? IconButton(
                                icon: const Icon(Icons.language, color: Colors.white),
                                onPressed: () {
                                  if (context.locale.languageCode == 'en') {
                                    context.setLocale(const Locale('ar'));
                                    NetworkService.currentLanguage = 'ar';
                                  } else {
                                    context.setLocale(const Locale('en'));
                                    NetworkService.currentLanguage = 'en';
                                  }
                                },
                                tooltip: context.locale.languageCode == 'en' ? 'العربية' : 'English',
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.language, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent.withOpacity(0.8),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Row(
                            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.accent,
                                radius: 18,
                                child: Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                              if (!isCollapsed) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(authState is AuthSuccess ? authState.user.name : 'User', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text(authState is AuthSuccess ? authState.user.email : '', style: const TextStyle(color: Colors.white54, fontSize: 10), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                // Exit Button
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.exit_to_app, color: Colors.redAccent, size: 20),
                                    tooltip: 'Exit',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Exit Application'),
                                          content: const Text('Are you sure you want to exit?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context.read<AuthCubit>().logout();
                                                context.go('/login');
                                              },
                                              child: const Text('Exit', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavGroup(BuildContext context, String title, IconData icon, List<NavItemData> items, bool isCollapsed) {
    if (items.isEmpty) return const SizedBox.shrink();

    final location = GoRouterState.of(context).uri.path;
    final isGroupSelected = items.any((item) => location.startsWith(item.path));

    if (isCollapsed) {
      return PopupMenuButton<String>(
        tooltip: title,
        offset: const Offset(70, 0),
        color: const Color(0xFF2A2D3E).withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        onSelected: (path) {
          context.go(path);
          if (MediaQuery.of(context).size.width < 900) {
            Navigator.pop(context);
          }
        },
        itemBuilder: (context) {
          return items.map((item) {
            final isSelected = location.startsWith(item.path);
            return PopupMenuItem<String>(
              value: item.path,
              child: Row(
                children: [
                  Icon(item.icon, color: isSelected ? AppColors.accent : Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? AppColors.accent : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isGroupSelected ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(icon, color: isGroupSelected ? AppColors.accent : Colors.white70),
          ),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isGroupSelected ? Colors.white.withOpacity(0.03) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          initiallyExpanded: isGroupSelected,
          leading: Icon(icon, color: isGroupSelected ? AppColors.accent : Colors.white70),
          title: Text(
            title,
            style: TextStyle(
              color: isGroupSelected ? Colors.white : Colors.white70,
              fontWeight: isGroupSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white70,
          childrenPadding: const EdgeInsets.only(left: 12, bottom: 8, right: 8),
          children: items.map((item) => _buildNavItem(context, item.title, item.icon, item.path, isCollapsed, isSubItem: true)).toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String path, bool isCollapsed, {bool isSubItem = false}) {
    final location = GoRouterState.of(context).uri.path;
    final isSelected = location.startsWith(path);

    Widget navContent = Container(
      margin: EdgeInsets.only(bottom: isSubItem ? 4 : 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: isCollapsed
            ? const EdgeInsets.symmetric(horizontal: 8)
            : EdgeInsets.symmetric(horizontal: isSubItem ? 12 : 16),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.accent : Colors.white70,
          size: isSubItem ? 20 : 24,
        ),
        title: isCollapsed
            ? null
            : Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.accent : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: isSubItem ? 13 : 14,
                ),
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          context.go(path);
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
