import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/appointment_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class ManageAppointmentsScreen extends ConsumerStatefulWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  ConsumerState<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState
    extends ConsumerState<ManageAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestoreService = FirestoreService();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDoctorAndAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctorAndAppointments() async {
    setState(() => _isLoading = true);
    try {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        // Find this doctor's profile by userId
        final doctorProfile =
            await _firestoreService.getDoctorByUserId(authState.user!.id);
        if (doctorProfile != null) {
          _appointments =
              await _firestoreService.getDoctorAppointments(doctorProfile.id);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  List<AppointmentModel> get _pending =>
      _appointments.where((a) => a.status == AppointmentStatus.pending).toList();

  List<AppointmentModel> get _confirmed =>
      _appointments.where((a) => a.status == AppointmentStatus.confirmed).toList();

  List<AppointmentModel> get _completed =>
      _appointments.where((a) => a.status == AppointmentStatus.completed).toList();

  List<AppointmentModel> get _cancelled =>
      _appointments.where((a) => a.status == AppointmentStatus.cancelled).toList();

  Future<void> _updateStatus(
    AppointmentModel appointment,
    AppointmentStatus newStatus,
  ) async {
    try {
      await _firestoreService.updateAppointmentStatus(
        appointment.id,
        newStatus,
      );
      await _loadDoctorAndAppointments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == AppointmentStatus.confirmed
                  ? 'Appointment confirmed!'
                  : newStatus == AppointmentStatus.cancelled
                      ? 'Appointment rejected'
                      : 'Appointment marked as ${newStatus.name}',
            ),
            backgroundColor:
                newStatus == AppointmentStatus.confirmed
                    ? AppColors.success
                    : AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Appointments'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Pending (${_pending.length})'),
            Tab(text: 'Confirmed (${_confirmed.length})'),
            Tab(text: 'Completed (${_completed.length})'),
            Tab(text: 'Cancelled (${_cancelled.length})'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_pending, showActions: true),
                _buildList(_confirmed, showComplete: true),
                _buildList(_completed),
                _buildList(_cancelled),
              ],
            ),
    );
  }

  Widget _buildList(
    List<AppointmentModel> appointments, {
    bool showActions = false,
    bool showComplete = false,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'No appointments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDoctorAndAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final apt = appointments[index];
          return _DoctorAppointmentCard(
            appointment: apt,
            showActions: showActions,
            showComplete: showComplete,
            onAccept: () =>
                _updateStatus(apt, AppointmentStatus.confirmed),
            onReject: () =>
                _updateStatus(apt, AppointmentStatus.cancelled),
            onComplete: () =>
                _updateStatus(apt, AppointmentStatus.completed),
          );
        },
      ),
    );
  }
}

class _DoctorAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool showActions;
  final bool showComplete;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const _DoctorAppointmentCard({
    required this.appointment,
    this.showActions = false,
    this.showComplete = false,
    this.onAccept,
    this.onReject,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
                  child: Text(
                    appointment.patientName.isNotEmpty
                        ? appointment.patientName[0]
                        : 'P',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            appointment.timeSlot,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Notes
            if (appointment.notes != null &&
                appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Actions (accept/reject for pending)
            if (showActions) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Complete button for confirmed
            if (showComplete) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
