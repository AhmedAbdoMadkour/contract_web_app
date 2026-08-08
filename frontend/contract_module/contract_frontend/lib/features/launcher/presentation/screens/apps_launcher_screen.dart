import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/cubit/auth_cubit.dart';
class AppsLauncherScreen extends StatelessWidget {
  const AppsLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top bar with Logo and Profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/sasheco_logo.png', height: 48),
                          const SizedBox(width: 16),
                          Text(
                            'SASHECO',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          String userName = 'User';
                          if (state is AuthSuccess) {
                            userName = state.user.name;
                          }
                          return Row(
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter, // Moved icons to the top
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80.0), // Give it some breathing room from the top bar
                      child: Wrap(
                        spacing: 48,
                        runSpacing: 48,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildAppModule(
                            context,
                            title: 'Contracts',
                            icon: Icons.description,
                            color: const Color(0xFF1E3A8A), // Deep Navy
                            iconColor: const Color(0xFFFBBF24), // Gold
                            onTap: () => context.go('/dashboard'),
                          ),
                          _buildAppModule(
                            context,
                            title: 'HR',
                            icon: Icons.people_alt,
                            color: const Color(0xFFFBBF24), // Gold
                            iconColor: const Color(0xFF1E3A8A), // Deep Navy
                            onTap: () {
                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('HR Module Coming Soon!')));
                            },
                          ),
                          _buildAppModule(
                            context,
                            title: 'Task Flow',
                            icon: Icons.account_tree,
                            color: const Color(0xFF374151), // Dark Gray/Navy
                            iconColor: const Color(0xFFFBBF24), // Gold
                            onTap: () {
                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task Flow Coming Soon!')));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppModule(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 64,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
