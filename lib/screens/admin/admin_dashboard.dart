import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/stat_card.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedIndex = 0;

  final List<_DrawerItem> _drawerItems = [
    _DrawerItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _DrawerItem(icon: Icons.medical_services_outlined, label: 'Doctors'),
    _DrawerItem(icon: Icons.people_outline, label: 'Patients'),
    _DrawerItem(icon: Icons.local_hospital_outlined, label: 'Clinics'),
    _DrawerItem(icon: Icons.analytics_outlined, label: 'Analytics'),
    _DrawerItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_drawerItems[_selectedIndex].label),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              label: const Text('5'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardView(),
          _buildDoctorsView(),
          _buildPatientsView(),
          _buildClinicsView(),
          _buildAnalyticsView(),
          _buildSettingsView(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final authState = ref.watch(authProvider);

    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authState.user?.name ?? 'Admin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  authState.user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _drawerItems.length,
              itemBuilder: (context, index) {
                final item = _drawerItems[index];
                final isSelected = _selectedIndex == index;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color:
                        isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          // Logout
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back, Admin!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening in your system today.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Grid
          Row(
            children: const [
              Expanded(
                child: StatCard(
                  title: 'Total Doctors',
                  value: '32',
                  icon: Icons.medical_services_outlined,
                  backgroundColor: AppColors.cardBlue,
                  iconColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Total Patients',
                  value: '1,248',
                  icon: Icons.people_outline,
                  backgroundColor: AppColors.cardGreen,
                  iconColor: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: StatCard(
                  title: 'Appointments',
                  value: '156',
                  icon: Icons.calendar_today_outlined,
                  backgroundColor: AppColors.cardOrange,
                  iconColor: AppColors.warning,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Clinics',
                  value: '5',
                  icon: Icons.local_hospital_outlined,
                  backgroundColor: AppColors.cardPurple,
                  iconColor: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Pending Approvals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending Doctor Approvals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          const SizedBox(height: 8),
          _DoctorApprovalCard(
            name: 'Dr. Ali Ahmed',
            specialization: 'Neurologist',
            experience: '10 years',
            onApprove: () {},
            onReject: () {},
          ),
          const SizedBox(height: 8),
          _DoctorApprovalCard(
            name: 'Dr. Hina Tariq',
            specialization: 'Gynecologist',
            experience: '7 years',
            onApprove: () {},
            onReject: () {},
          ),
          const SizedBox(height: 20),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _ActivityItem(
            icon: Icons.person_add,
            color: AppColors.success,
            title: 'New patient registered',
            subtitle: 'Zara Khan • 2 minutes ago',
          ),
          _ActivityItem(
            icon: Icons.calendar_month,
            color: AppColors.primary,
            title: 'Appointment booked',
            subtitle: 'Ahmed → Dr. Sarah • 15 minutes ago',
          ),
          _ActivityItem(
            icon: Icons.medical_services,
            color: AppColors.warning,
            title: 'Doctor application received',
            subtitle: 'Dr. Ali Ahmed • 1 hour ago',
          ),
          _ActivityItem(
            icon: Icons.star_rounded,
            color: AppColors.accent,
            title: 'New review submitted',
            subtitle: 'Ayesha → Dr. Usman (5 stars) • 2 hours ago',
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and filter
          TextField(
            decoration: InputDecoration(
              hintText: 'Search doctors...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _AdminDoctorItem(
                  name: 'Dr. Sarah Ali',
                  specialization: 'Cardiologist',
                  isApproved: true,
                  patients: 148,
                  rating: 4.8,
                ),
                _AdminDoctorItem(
                  name: 'Dr. Usman Raza',
                  specialization: 'Dermatologist',
                  isApproved: true,
                  patients: 89,
                  rating: 4.6,
                ),
                _AdminDoctorItem(
                  name: 'Dr. Fatima Noor',
                  specialization: 'Pediatrician',
                  isApproved: true,
                  patients: 210,
                  rating: 4.9,
                ),
                _AdminDoctorItem(
                  name: 'Dr. Ali Ahmed',
                  specialization: 'Neurologist',
                  isApproved: false,
                  patients: 0,
                  rating: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _AdminPatientItem(
                  name: 'Ahmed Khan',
                  email: 'ahmed@email.com',
                  appointments: 12,
                  joinDate: 'Jan 2026',
                ),
                _AdminPatientItem(
                  name: 'Ayesha Malik',
                  email: 'ayesha@email.com',
                  appointments: 8,
                  joinDate: 'Mar 2026',
                ),
                _AdminPatientItem(
                  name: 'Hassan Ali',
                  email: 'hassan@email.com',
                  appointments: 3,
                  joinDate: 'Jul 2026',
                ),
                _AdminPatientItem(
                  name: 'Zainab Fatima',
                  email: 'zainab@email.com',
                  appointments: 5,
                  joinDate: 'Jun 2026',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicsView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add clinic button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add New Clinic'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _ClinicCard(
                  name: 'City Heart Hospital',
                  address: 'Gulberg III, Lahore',
                  doctors: 8,
                  isActive: true,
                ),
                _ClinicCard(
                  name: 'MedCare Clinic',
                  address: 'DHA Phase 5, Lahore',
                  doctors: 5,
                  isActive: true,
                ),
                _ClinicCard(
                  name: 'HealthFirst Center',
                  address: 'Model Town, Lahore',
                  doctors: 12,
                  isActive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Text(
            'System Analytics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          // Stats
          Row(
            children: const [
              Expanded(
                child: StatCard(
                  title: 'This Week',
                  value: '45',
                  icon: Icons.trending_up,
                  backgroundColor: AppColors.cardBlue,
                  iconColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'This Month',
                  value: '156',
                  icon: Icons.analytics,
                  backgroundColor: AppColors.cardGreen,
                  iconColor: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Popular Specializations
          Text(
            'Popular Specializations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _SpecializationStat(
            name: 'Cardiologist',
            appointments: 45,
            percentage: 0.35,
          ),
          _SpecializationStat(
            name: 'Dermatologist',
            appointments: 32,
            percentage: 0.25,
          ),
          _SpecializationStat(
            name: 'Pediatrician',
            appointments: 28,
            percentage: 0.22,
          ),
          _SpecializationStat(
            name: 'General Physician',
            appointments: 23,
            percentage: 0.18,
          ),
          const SizedBox(height: 24),
          Text(
            'Peak Hours',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _PeakHourItem(time: '09:00 - 11:00 AM', percentage: 0.8),
                  _PeakHourItem(time: '02:00 - 04:00 PM', percentage: 0.65),
                  _PeakHourItem(time: '11:00 - 01:00 PM', percentage: 0.45),
                  _PeakHourItem(time: '04:00 - 06:00 PM', percentage: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notification Templates',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsItem(
                  icon: Icons.access_time,
                  title: 'Default Time Slots',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsItem(
                  icon: Icons.category_outlined,
                  title: 'Specializations',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsItem(
                  icon: Icons.security,
                  title: 'Security Settings',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsItem(
                  icon: Icons.backup_outlined,
                  title: 'Data Backup',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsItem(
                  icon: Icons.info_outline,
                  title: 'About App',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;

  _DrawerItem({required this.icon, required this.label});
}

class _DoctorApprovalCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String experience;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _DoctorApprovalCard({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.warning.withValues(alpha: 0.2),
              child: const Icon(
                Icons.medical_services,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '$specialization • $experience',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onReject,
              icon: const Icon(Icons.close, color: AppColors.error),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onApprove,
              icon: const Icon(Icons.check, color: AppColors.success),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminDoctorItem extends StatelessWidget {
  final String name;
  final String specialization;
  final bool isApproved;
  final int patients;
  final double rating;

  const _AdminDoctorItem({
    required this.name,
    required this.specialization,
    required this.isApproved,
    required this.patients,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isApproved
              ? AppColors.secondary.withValues(alpha: 0.2)
              : AppColors.warning.withValues(alpha: 0.2),
          child: Icon(
            Icons.medical_services,
            color: isApproved ? AppColors.secondary : AppColors.warning,
          ),
        ),
        title: Text(name),
        subtitle: Text(
          isApproved
              ? '$specialization • $patients patients • ⭐ $rating'
              : '$specialization • Pending Approval',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isApproved
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isApproved ? 'Active' : 'Pending',
            style: TextStyle(
              color: isApproved ? AppColors.success : AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _AdminPatientItem extends StatelessWidget {
  final String name;
  final String email;
  final int appointments;
  final String joinDate;

  const _AdminPatientItem({
    required this.name,
    required this.email,
    required this.appointments,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
          child: Text(
            name[0],
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(name),
        subtitle: Text('$email • $appointments appointments • Since $joinDate'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
          ],
          onSelected: (value) {},
        ),
        onTap: () {},
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final String name;
  final String address;
  final int doctors;
  final bool isActive;

  const _ClinicCard({
    required this.name,
    required this.address,
    required this.doctors,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_hospital,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$doctors doctors',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecializationStat extends StatelessWidget {
  final String name;
  final int appointments;
  final double percentage;

  const _SpecializationStat({
    required this.name,
    required this.appointments,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              Text(
                '$appointments appointments',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.surfaceVariant,
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeakHourItem extends StatelessWidget {
  final String time;
  final double percentage;

  const _PeakHourItem({
    required this.time,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.surfaceVariant,
                color: percentage > 0.6
                    ? AppColors.primary
                    : AppColors.primaryLight,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
