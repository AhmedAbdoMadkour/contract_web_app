import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/core/widgets/app_background.dart';
import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const Scaffold(backgroundColor: Colors.transparent, body: {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            // Sidebar with Glassmorphism
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9), // Glass sidebar
                    border: Border(
                      right: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Logo
                      Row(
                        children: [
                          const SizedBox(width: 24),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset('assets/images/logo.png', width: 24, height: 24),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SASHECO',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Enterprise Hub',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 48),
                      // Navigation Links
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildNavItem(context, AppLocalizations.of(context)?.overview ?? 'Dashboard', Icons.dashboard, '/dashboard', location),
                            _buildNavItem(context, AppLocalizations.of(context)?.createUser ?? 'Create User', Icons.person_add, '/create-user', location),
                            _buildNavItem(context, AppLocalizations.of(context)?.globalPermissionsControl ?? 'Global Permissions', Icons.admin_panel_settings, '/global-permissions', location),
                            _buildNavItem(context, 'Engineering', Icons.engineering, '/engineering', location),
                            _buildNavItem(context, 'Secretary', Icons.edit_document, '/secretary', location),
                            _buildNavItem(context, AppLocalizations.of(context)?.sashecoFinancial ?? 'Financial', Icons.attach_money, '/financial', location),
                            _buildNavItem(context, 'Contract Approval', Icons.gavel, '/approval', location),
                            _buildNavItem(context, AppLocalizations.of(context)?.vendorManagement ?? 'Vendor Data', Icons.store, '/vendor', location),
                            _buildNavItem(context, 'Site Data', Icons.location_on, '/site', location),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top App Bar with Glassmorphism
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.45), // Glass topbar
                          border: Border(
                            bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.help_outline, color: AppColors.textSecondary),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 24),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: child, // The child (e.g. GlassContainer) will render here
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, String currentLocation) {
    final bool isActive = currentLocation == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? const Border(left: BorderSide(color: AppColors.accent, width: 4))
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? AppColors.accent : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          context.go(route);
        },
      ),
    );
  }
}
