enum AppointmentStatus { pending, confirmed, inProgress, completed, cancelled }

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final DateTime dateTime;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final String? videoCallLink;
  final String? prescriptionId;
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.dateTime,
    required this.timeSlot,
    this.status = AppointmentStatus.pending,
    this.notes,
    this.videoCallLink,
    this.prescriptionId,
    required this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? specialization,
    DateTime? dateTime,
    String? timeSlot,
    AppointmentStatus? status,
    String? notes,
    String? videoCallLink,
    String? prescriptionId,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      dateTime: dateTime ?? this.dateTime,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      videoCallLink: videoCallLink ?? this.videoCallLink,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'dateTime': dateTime.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status.name,
      'notes': notes,
      'videoCallLink': videoCallLink,
      'prescriptionId': prescriptionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String docId) {
    return AppointmentModel(
      id: docId,
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialization: map['specialization'] ?? '',
      dateTime: DateTime.parse(
        map['dateTime'] ?? DateTime.now().toIso8601String(),
      ),
      timeSlot: map['timeSlot'] ?? '',
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      notes: map['notes'],
      videoCallLink: map['videoCallLink'],
      prescriptionId: map['prescriptionId'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}
