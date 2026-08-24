import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/appointment_model.dart';
import '../utils/date_formatter.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool showDoctor;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.showDoctor = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                    child: Icon(
                      showDoctor ? Icons.medical_services : Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showDoctor
                              ? appointment.doctorName
                              : appointment.patientName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appointment.specialization,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  _StatusBadge(status: appointment.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormatter.formatDate(appointment.dateTime),
                  ),
                  const SizedBox(width: 16),
                  _InfoChip(
                    icon: Icons.access_time_outlined,
                    text: appointment.timeSlot,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case AppointmentStatus.pending:
        bgColor = AppColors.statusPending.withValues(alpha: 0.15);
        textColor = AppColors.statusPending;
        break;
      case AppointmentStatus.confirmed:
        bgColor = AppColors.statusConfirmed.withValues(alpha: 0.15);
        textColor = AppColors.statusConfirmed;
        break;
      case AppointmentStatus.inProgress:
        bgColor = AppColors.statusInProgress.withValues(alpha: 0.15);
        textColor = AppColors.statusInProgress;
        break;
      case AppointmentStatus.completed:
        bgColor = AppColors.statusCompleted.withValues(alpha: 0.15);
        textColor = AppColors.statusCompleted;
        break;
      case AppointmentStatus.cancelled:
        bgColor = AppColors.statusCancelled.withValues(alpha: 0.15);
        textColor = AppColors.statusCancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name[0].toUpperCase() + status.name.substring(1),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
