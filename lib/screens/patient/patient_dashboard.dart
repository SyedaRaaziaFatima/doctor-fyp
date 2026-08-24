import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/appointment_model.dart';
import '../../models/doctor_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/common/stat_card.dart';

class PatientDashboard extends ConsumerStatefulWidget {
  const PatientDashboard({super.key});

  @override
  ConsumerState<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends ConsumerState<PatientDashboard> {
  int _currentIndex = 0;

  // Mock data for UI preview
  final List<AppointmentModel> _upcomingAppointments = [
    AppointmentModel(
      id: '1',
      patientId: 'p1',
      patientName: 'Ahmed Khan',
      doctorId: 'd1',
      doctorName: 'Dr. Sarah Ali',
      specialization: 'Cardiologist',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '10:00 AM',
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
    ),
    AppointmentModel(
      id: '2',
      patientId: 'p1',
      patientName: 'Ahmed Khan',
      doctorId: 'd2',
      doctorName: 'Dr. Usman Raza',
      specialization: 'Dermatologist',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      timeSlot: '02:30 PM',
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];

  final List<DoctorModel> _topDoctors = [
    const DoctorModel(
      id: 'd1',
      userId: 'u1',
      name: 'Dr. Sarah Ali',
      email: 'sarah@doc.com',
      phone: '+92 300 1111111',
      specialization: 'Cardiologist',
      experienceYears: 12,
      bio: 'Experienced cardiologist with 12 years of practice.',
      consultationFee: 2000,
      isApproved: true,
      averageRating: 4.8,
      totalReviews: 124,
    ),
    const DoctorModel(
      id: 'd2',
      userId: 'u2',
      name: 'Dr. Usman Raza',
      email: 'usman@doc.com',
      phone: '+92 300 2222222',
      specialization: 'Dermatologist',
      experienceYears: 8,
      bio: 'Specialist in skin conditions and treatments.',
      consultationFee: 1500,
      isApproved: true,
      averageRating: 4.6,
      totalReviews: 89,
    ),
    const DoctorModel(
      id: 'd3',
      userId: 'u3',
      name: 'Dr. Fatima Noor',
      email: 'fatima@doc.com',
      phone: '+92 300 3333333',
      specialization: 'Pediatrician',
      experienceYears: 15,
      bio: 'Caring pediatrician with extensive experience.',
      consultationFee: 1800,
      isApproved: true,
      averageRating: 4.9,
      totalReviews: 210,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'User';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(userName),
          _buildAppointmentsTab(),
          _buildDiagnosticsTab(),
          _buildChatTab(),
          _buildProfileTab(authState),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety_rounded),
            label: 'Diagnostics',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(String userName) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatter.greetingMessage(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                // Notification & Avatar
                IconButton(
                  onPressed: () {},
                  icon: Badge(
                    smallSize: 8,
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Action Cards
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.search_rounded,
                    label: 'Find\nDoctors',
                    color: AppColors.primary,
                    bgColor: AppColors.cardBlue,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.health_and_safety_rounded,
                    label: 'Symptom\nChecker',
                    color: AppColors.secondary,
                    bgColor: AppColors.cardGreen,
                    onTap: () {
                      setState(() => _currentIndex = 2);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.folder_shared_rounded,
                    label: 'My\nRecords',
                    color: AppColors.accent,
                    bgColor: AppColors.cardPurple,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Upcoming Appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Appointments',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _currentIndex = 1);
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_upcomingAppointments.isEmpty)
              _buildEmptyState(
                icon: Icons.calendar_today_outlined,
                message: 'No upcoming appointments',
              )
            else
              ..._upcomingAppointments.map(
                (apt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppointmentCard(appointment: apt),
                ),
              ),
            const SizedBox(height: 20),

            // Top Doctors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Doctors',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._topDoctors.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DoctorCard(
                  doctor: doc,
                  onBookNow: () {},
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Appointments',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            // Tab chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', isSelected: true, onTap: () {}),
                  _FilterChip(label: 'Upcoming', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Completed', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Cancelled', isSelected: false, onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _upcomingAppointments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppointmentCard(
                      appointment: _upcomingAppointments[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticsTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health & Diagnostics',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            // Symptom Checker Card
            _buildFeatureCard(
              icon: Icons.medical_information_rounded,
              title: 'Symptom Checker',
              description: 'Enter your symptoms and get instant health insights',
              color: AppColors.primary,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            // BMI Calculator
            _buildFeatureCard(
              icon: Icons.monitor_weight_rounded,
              title: 'BMI Calculator',
              description: 'Calculate your Body Mass Index',
              color: AppColors.secondary,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            // Health Metrics
            _buildFeatureCard(
              icon: Icons.favorite_rounded,
              title: 'Health Metrics',
              description: 'Track blood pressure, heart rate & more',
              color: AppColors.error,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            // Quick Stats
            Text(
              'Your Health Summary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: StatCard(
                    title: 'BMI',
                    value: '22.5',
                    icon: Icons.monitor_weight_outlined,
                    backgroundColor: AppColors.cardGreen,
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Heart Rate',
                    value: '72',
                    icon: Icons.favorite_outline,
                    backgroundColor: Color(AppColors.error.toARGB32()).withValues(alpha: 0.08) == Colors.transparent ? AppColors.cardOrange : const Color(0xFFFCE4EC),
                    iconColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildEmptyState(
                icon: Icons.chat_bubble_outline_rounded,
                message: 'No messages yet.\nBook an appointment to start a conversation.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(AuthState authState) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile header
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              authState.user?.name ?? 'User',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              authState.user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            // Menu items
            _ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.folder_shared_outlined,
              title: 'Medical Records',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'Prescriptions',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.star_outline_rounded,
              title: 'My Reviews',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProfileMenuItem(
              icon: Icons.logout_rounded,
              title: 'Log Out',
              isDestructive: true,
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDestructive ? AppColors.error : AppColors.textHint,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
