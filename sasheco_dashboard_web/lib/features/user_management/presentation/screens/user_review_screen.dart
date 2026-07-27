import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import '../cubit/user_management_cubit.dart';
import '../cubit/user_management_state.dart';
import '../../data/model/user_model.dart';

enum UserViewMode { kanban, list }

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({super.key});

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  UserViewMode _currentViewMode = UserViewMode.kanban;
  String _searchQuery = '';
  String _selectedRoleFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserManagementCubit>().loadUsers();
    });
  }

  final List<UserModel> _fallbackDemoUsers = const [
    UserModel(
      id: '1',
      name: 'Emma Smith',
      email: 'emma.smith@sasheco.com',
      role: 'AI Coach & Lead',
      isActive: true,
    ),
    UserModel(
      id: '2',
      name: 'William Hall',
      email: 'william.hall@sasheco.com',
      role: 'Cybersecurity Trainer',
      isActive: true,
    ),
    UserModel(
      id: '3',
      name: 'Sally Kelly',
      email: 'sally.kelly@sasheco.com',
      role: 'English for IT Specialist',
      isActive: true,
    ),
    UserModel(
      id: '4',
      name: 'Liam Lee',
      email: 'liam.lee@sasheco.com',
      role: 'Web Development Lead',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<UserManagementCubit, UserManagementState>(
        listener: (context, state) {
          if (state is UserManagementOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is UserManagementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          List<UserModel> users = [];
          if (state is UserManagementLoaded) {
            users = state.users.isNotEmpty ? state.users : _fallbackDemoUsers;
          } else {
            users = _fallbackDemoUsers;
          }

          final filteredUsers = users.where((u) {
            final matchesSearch = u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.role.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesFilter = _selectedRoleFilter == 'All' ||
                (_selectedRoleFilter == 'Active' && u.isActive) ||
                (_selectedRoleFilter == 'Inactive' && !u.isActive);
            return matchesSearch && matchesFilter;
          }).toList();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildFilterAndToggleRow(context),
                    const SizedBox(height: 24),
                    if (_currentViewMode == UserViewMode.kanban)
                      _buildKanbanView(context, filteredUsers)
                    else
                      _buildListView(context, filteredUsers),
                  ],
                ),
              ),
              if (state is UserManagementLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users Created Review',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upcoming team timetable & member access directory',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            _buildStatBadge('13k+', 'Users added\nour extension'),
            const SizedBox(width: 24),
            Container(width: 1, height: 40, color: AppColors.border),
            const SizedBox(width: 24),
            _buildStatBadge('85%', 'Growth in\nonline learning'),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/create-user');
              },
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add New User', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBadge(String number, String label) {
    return Row(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterAndToggleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 280,
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search users or roles...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'All', label: Text('All')),
                ButtonSegment(value: 'Active', label: Text('Active')),
                ButtonSegment(value: 'Inactive', label: Text('Inactive')),
              ],
              selected: {_selectedRoleFilter},
              onSelectionChanged: (set) {
                setState(() => _selectedRoleFilter = set.first);
              },
            ),
          ],
        ),
        // Toggle view mode (Kanban vs List)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildToggleOption(
                icon: Icons.view_kanban_outlined,
                label: 'Kanban View',
                isSelected: _currentViewMode == UserViewMode.kanban,
                onTap: () => setState(() => _currentViewMode = UserViewMode.kanban),
              ),
              const SizedBox(width: 4),
              _buildToggleOption(
                icon: Icons.format_list_bulleted,
                label: 'List View',
                isSelected: _currentViewMode == UserViewMode.list,
                onTap: () => setState(() => _currentViewMode = UserViewMode.list),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- KANBAN VIEW (Attachment 1 Inspiration) ---
  Widget _buildKanbanView(BuildContext context, List<UserModel> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Featured Card inspired by Attachment 1
        _buildHeroBannerCard(context),
        const SizedBox(height: 24),
        // Kanban Columns
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildKanbanColumn(
                context,
                title: 'Active Experts',
                count: users.where((u) => u.isActive).length,
                color: AppColors.success,
                users: users.where((u) => u.isActive).toList(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildKanbanColumn(
                context,
                title: 'Review / Inactive',
                count: users.where((u) => !u.isActive).length,
                color: AppColors.warning,
                users: users.where((u) => !u.isActive).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroBannerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF2C3E6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.workspace_premium, size: 16, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text(
                            'Clawverly Hub',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Learn anywhere,\nanytime.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle_fill, color: AppColors.primary),
                      label: const Text('Overview Demo', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Download app on sasheco.com',
                      style: TextStyle(color: Colors.white70, fontSize: 13, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 4),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context, {
    required String title,
    required int count,
    required Color color,
    required List<UserModel> users,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (users.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text('No users in this column', style: TextStyle(color: AppColors.textDisabled)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildKanbanUserCard(context, users[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildKanbanUserCard(BuildContext context, UserModel user) {
    final demoImages = [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
    ];
    final imageUrl = demoImages[user.name.hashCode.abs() % demoImages.length];

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Top action button overlay
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                  onSelected: (val) {
                    if (val == 'toggle') {
                      context.read<UserManagementCubit>().updateUser(
                            UserModel(
                              id: user.id,
                              name: user.name,
                              email: user.email,
                              role: user.role,
                              isActive: !user.isActive,
                            ),
                          );
                    } else if (val == 'delete') {
                      context.read<UserManagementCubit>().deleteUser(user.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(user.isActive ? 'Deactivate User' : 'Activate User'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete User', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
            // Glassmorphic Bottom Overlay Container (Matching attached design)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.65),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.role.isNotEmpty ? user.role : 'UX/UI Designer',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Glassy Pill Badge (exact match to $1,200 pill in screenshot)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        user.isActive ? '\$1,200' : 'Pending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LIST VIEW (Attachment 2 Inspiration) ---
  Widget _buildListView(BuildContext context, List<UserModel> users) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming classes with experts\' timetable',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Row(
                children: [
                  _buildStatBadge('13k+', 'Users added\nour extension'),
                  const SizedBox(width: 24),
                  _buildStatBadge('85%', 'Growth in\nonline learning'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Table Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Teacher\'s name / Role', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                Expanded(flex: 3, child: Text('Lesson / Email', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                Expanded(flex: 2, child: Text('Level / Status', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                Expanded(flex: 2, child: Text('Time / Access', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
                SizedBox(width: 48, child: Text('Action', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 12))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildListUserPillRow(context, users[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildListUserPillRow(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Teacher Name & Avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
                    ),
                    Text(
                      user.role.isNotEmpty ? user.role : 'Coach',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Lesson / Email
          Expanded(
            flex: 3,
            child: Text(
              user.email,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          // Level / Status Pill
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bar_chart, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        user.isActive ? 'Beginner' : 'Intermediate',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Date
          Expanded(
            flex: 2,
            child: Row(
              children: const [
                Icon(Icons.calendar_month, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text('12.10.2026', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          // Time
          Expanded(
            flex: 2,
            child: Row(
              children: const [
                Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text('10:00-12:00', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          // Action Three-dots
          SizedBox(
            width: 48,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
              onSelected: (val) {
                if (val == 'toggle') {
                  context.read<UserManagementCubit>().updateUser(
                        UserModel(
                          id: user.id,
                          name: user.name,
                          email: user.email,
                          role: user.role,
                          isActive: !user.isActive,
                        ),
                      );
                } else if (val == 'delete') {
                  context.read<UserManagementCubit>().deleteUser(user.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(user.isActive ? 'Deactivate' : 'Activate'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
