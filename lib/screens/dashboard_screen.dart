import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _databaseService = DatabaseService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  int _selectedIndex = 0;

  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  // Sample notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Welcome!',
      'message': 'Thanks for joining our app. Explore all features!',
      'time': 'Just now',
      'read': false,
      'icon': Icons.celebration,
    },
    {
      'title': 'Profile Updated',
      'message': 'Your profile has been successfully updated.',
      'time': '2 hours ago',
      'read': true,
      'icon': Icons.person,
    },
    {
      'title': 'Security Alert',
      'message': 'New login detected from Chrome on Windows.',
      'time': 'Yesterday',
      'read': true,
      'icon': Icons.security,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      // No user logged in, redirect to login
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    // Set default profile from Firebase Auth user
    Map<String, dynamic> defaultProfile = {
      'name': user.displayName ?? user.email?.split('@')[0] ?? 'User',
      'email': user.email ?? '',
      'phone': 'Not provided',
      'photoUrl': user.photoURL,
    };

    try {
      final profile = await _databaseService.getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile ?? defaultProfile;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Database error - use default profile from Auth
      if (mounted) {
        setState(() {
          _userProfile = defaultProfile;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadUserProfile,
              tooltip: 'Refresh',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(),
                _buildNotificationsTab(),
                _buildSettingsTab(),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
            icon: Badge(
              label: Text('${_notifications.where((n) => !n['read']).length}'),
              isLabelVisible: _notifications.any((n) => !n['read']),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: 'Notifications',
          ),
          const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Notifications';
      case 2:
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _loadUserProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User greeting card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: _userProfile?['photoUrl'] != null
                        ? NetworkImage(_userProfile!['photoUrl'])
                        : null,
                    child: _userProfile?['photoUrl'] == null
                        ? Text(
                            (_userProfile?['name'] ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFF1E3A8A),
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14),
                        ),
                        Text(
                          _userProfile?['name'] ?? 'User',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userProfile?['email'] ?? '',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            const Text('Quick Stats',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildStatCard(
                        'Profile', '100%', Icons.person, Colors.green)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildStatCard(
                        'Messages',
                        '${_notifications.length}',
                        Icons.message,
                        Colors.blue)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildStatCard(
                        'Tasks', '5', Icons.task_alt, Colors.orange)),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text('Quick Actions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A))),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                    Icons.edit, 'Edit Profile', const Color(0xFF1E3A8A),
                    () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()));
                  if (result == true) _loadUserProfile();
                }),
                _buildActionCard(
                    Icons.notifications,
                    'Notifications',
                    const Color(0xFF2563EB),
                    () => setState(() => _selectedIndex = 1)),
                _buildActionCard(
                    Icons.settings,
                    'Settings',
                    const Color(0xFF3B82F6),
                    () => setState(() => _selectedIndex = 2)),
                _buildActionCard(Icons.help, 'Help', const Color(0xFF60A5FA),
                    () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Help center coming soon!')));
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity
            const Text('Recent Activity',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A))),
            const SizedBox(height: 12),
            _buildActivityCard(
                'Login successful', 'Just now', Icons.login, Colors.green),
            _buildActivityCard(
                'Profile viewed', '1 hour ago', Icons.visibility, Colors.blue),
            _buildActivityCard(
                'Settings updated', 'Yesterday', Icons.settings, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return _notifications.isEmpty
        ? const Center(
            child: Text('No notifications',
                style: TextStyle(color: Colors.grey, fontSize: 16)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notif = _notifications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: notif['read'] ? Colors.white : const Color(0xFFE8F0FE),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                    child: Icon(notif['icon'], color: const Color(0xFF1E3A8A)),
                  ),
                  title: Text(notif['title'],
                      style: TextStyle(
                          fontWeight: notif['read']
                              ? FontWeight.normal
                              : FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif['message'],
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(notif['time'],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  trailing: !notif['read']
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF1E3A8A), shape: BoxShape.circle))
                      : null,
                  onTap: () => setState(() => notif['read'] = true),
                ),
              );
            },
          );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingsSection('Account', [
          _buildSettingsTile(
              Icons.person, 'Profile', _userProfile?['email'] ?? '', () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()));
            if (result == true) _loadUserProfile();
          }),
          _buildSettingsTile(
              Icons.lock, 'Change Password', 'Update your password', () async {
            try {
              await _authService
                  .resetPassword(_authService.currentUser?.email ?? '');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Password reset email sent!'),
                    backgroundColor: Colors.green));
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: $e'), backgroundColor: Colors.red));
            }
          }),
        ]),
        const SizedBox(height: 16),
        _buildSettingsSection('Notifications', [
          _buildSwitchTile(
              Icons.notifications,
              'Push Notifications',
              _pushNotifications,
              (v) => setState(() => _pushNotifications = v)),
          _buildSwitchTile(
              Icons.email,
              'Email Notifications',
              _emailNotifications,
              (v) => setState(() => _emailNotifications = v)),
        ]),
        const SizedBox(height: 16),
        _buildSettingsSection('About', [
          _buildSettingsTile(Icons.info, 'App Version', '1.0.0', () {}),
          _buildSettingsTile(
              Icons.code,
              'Firebase Status',
              _authService.isFirebaseConnected ? 'Connected' : 'Disconnected',
              () {}),
        ]),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _handleLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ]),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }

  Widget _buildActivityCard(
      String title, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing:
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A8A))),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
              ]),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
      IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1E3A8A)),
    );
  }
}
