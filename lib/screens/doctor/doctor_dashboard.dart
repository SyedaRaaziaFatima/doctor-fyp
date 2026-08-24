import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/appointment_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/common/stat_card.dart';

class DoctorDashboard extends ConsumerStatefulWidget {
  const DoctorDashboard({super.key});

  @override
  ConsumerState<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends ConsumerState<DoctorDashboard> {
  int _currentIndex = 0;

  // Mock data
  final List<AppointmentModel> _todayAppointments = [
    AppointmentModel(
      id: '1',
      patientId: 'p1',
      patientName: 'Ahmed Khan',
      doctorId: 'd1',
      doctorName: 'Dr. Sarah Ali',
      specialization: 'Cardiologist',
      dateTime: DateTime.now(),
      timeSlot: '10:00 AM',
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
    ),
    AppointmentModel(
      id: '2',
      patientId: 'p2',
      patientName: 'Ayesha Malik',
      doctorId: 'd1',
      doctorName: 'Dr. Sarah Ali',
      specialization: 'Cardiologist',
      dateTime: DateTime.now(),
      timeSlot: '11:30 AM',
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
    ),
    AppointmentModel(
      id: '3',
      patientId: 'p3',
      patientName: 'Hassan Ali',
      doctorId: 'd1',
      doctorName: 'Dr. Sarah Ali',
      specialization: 'Cardiologist',
      dateTime: DateTime.now(),
      timeSlot: '02:00 PM',
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?.name ?? 'Doctor';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(userName),
          _buildScheduleTab(),
          _buildPatientsTab(),
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
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Patients',
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
                IconButton(
                  onPressed: () {},
                  icon: Badge(
                    label: const Text('3'),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    title: 'Total Patients',
                    value: '148',
                    icon: Icons.people_outline,
                    backgroundColor: AppColors.cardBlue,
                    iconColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Today\'s Appts',
                    value: '8',
                    icon: Icons.calendar_today_outlined,
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
                    title: 'Pending',
                    value: '3',
                    icon: Icons.pending_actions_outlined,
                    backgroundColor: AppColors.cardOrange,
                    iconColor: AppColors.warning,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Rating',
                    value: '4.8',
                    icon: Icons.star_outline_rounded,
                    backgroundColor: AppColors.cardPurple,
                    iconColor: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Today's Schedule
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Schedule",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _currentIndex = 1);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._todayAppointments.map(
              (apt) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppointmentCard(
                  appointment: apt,
                  showDoctor: false,
                  onTap: () {},
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pending Requests section
            Text(
              'Pending Requests',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _PendingRequestCard(
              patientName: 'Hassan Ali',
              reason: 'Chest Pain, Shortness of breath',
              date: 'Tomorrow, 03:00 PM',
              onAccept: () {},
              onReject: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Schedule',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormatter.formatFullDay(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todayAppointments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ScheduleItem(
                      appointment: _todayAppointments[index],
                      index: index,
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

  Widget _buildPatientsTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Patients',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            // Search bar
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
                  _PatientListItem(
                    name: 'Ahmed Khan',
                    lastVisit: 'Last visit: Aug 15, 2026',
                    condition: 'Hypertension',
                  ),
                  _PatientListItem(
                    name: 'Ayesha Malik',
                    lastVisit: 'Last visit: Aug 12, 2026',
                    condition: 'Arrhythmia',
                  ),
                  _PatientListItem(
                    name: 'Hassan Ali',
                    lastVisit: 'New Patient',
                    condition: 'Chest Pain',
                  ),
                  _PatientListItem(
                    name: 'Zainab Fatima',
                    lastVisit: 'Last visit: Jul 28, 2026',
                    condition: 'Heart Murmur',
                  ),
                ],
              ),
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
            // Mock chat list
            _ChatListItem(
              name: 'Ahmed Khan',
              lastMessage: 'Thank you, doctor!',
              time: '2m ago',
              unread: 1,
            ),
            _ChatListItem(
              name: 'Ayesha Malik',
              lastMessage: 'When should I take the medicine?',
              time: '1h ago',
              unread: 0,
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
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              child: const Icon(
                Icons.medical_services,
                size: 50,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              authState.user?.name ?? 'Doctor',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Cardiologist • 12 yrs experience',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
                const SizedBox(width: 4),
                const Text(
                  '4.8',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Text(' (124 reviews)'),
              ],
            ),
            const SizedBox(height: 32),
            _ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.access_time,
              title: 'Manage Availability',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'My Prescriptions',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
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
}

class _PendingRequestCard extends StatelessWidget {
  final String patientName;
  final String reason;
  final String date;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingRequestCard({
    required this.patientName,
    required this.reason,
    required this.date,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.statusPending.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.statusPending,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Reason: $reason',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final AppointmentModel appointment;
  final int index;

  const _ScheduleItem({required this.appointment, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time
        SizedBox(
          width: 72,
          child: Text(
            appointment.timeSlot,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        // Timeline dot
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: appointment.status == AppointmentStatus.confirmed
                    ? AppColors.primary
                    : AppColors.statusPending,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 80,
              color: AppColors.textHint.withValues(alpha: 0.2),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Card
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reason: General Checkup',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientListItem extends StatelessWidget {
  final String name;
  final String lastVisit;
  final String condition;

  const _PatientListItem({
    required this.name,
    required this.lastVisit,
    required this.condition,
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
        subtitle: Text('$lastVisit • $condition'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;

  const _ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
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
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (unread > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {},
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
