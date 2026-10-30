import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import '../models/appointment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Users ====================

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // ==================== Patients ====================

  Future<void> createPatientProfile(PatientModel patient) async {
    await _firestore.collection('patients').doc(patient.id).set(patient.toMap());
  }

  Future<PatientModel?> getPatientProfile(String patientId) async {
    final doc = await _firestore.collection('patients').doc(patientId).get();
    if (doc.exists && doc.data() != null) {
      return PatientModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<PatientModel?> getPatientByUserId(String userId) async {
    final query = await _firestore
        .collection('patients')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return PatientModel.fromMap(query.docs.first.data(), query.docs.first.id);
    }
    return null;
  }

  // ==================== Doctors ====================

  Future<void> createDoctorProfile(DoctorModel doctor) async {
    await _firestore.collection('doctors').doc(doctor.id).set(doctor.toMap());
  }

  Future<DoctorModel?> getDoctorProfile(String doctorId) async {
    final doc = await _firestore.collection('doctors').doc(doctorId).get();
    if (doc.exists && doc.data() != null) {
      return DoctorModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<DoctorModel?> getDoctorByUserId(String userId) async {
    final query = await _firestore
        .collection('doctors')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return DoctorModel.fromMap(query.docs.first.data(), query.docs.first.id);
    }
    return null;
  }

  /// Get all approved doctors
  Future<List<DoctorModel>> getApprovedDoctors() async {
    final query = await _firestore
        .collection('doctors')
        .where('isApproved', isEqualTo: true)
        .get();
    return query.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Get approved doctors filtered by specialization
  Future<List<DoctorModel>> getDoctorsBySpecialization(
    String specialization,
  ) async {
    final query = await _firestore
        .collection('doctors')
        .where('isApproved', isEqualTo: true)
        .where('specialization', isEqualTo: specialization)
        .get();
    return query.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Search doctors by name (client-side filtering — Firestore doesn't support LIKE)
  Future<List<DoctorModel>> searchDoctors(String searchTerm) async {
    final allDoctors = await getApprovedDoctors();
    final lowerSearch = searchTerm.toLowerCase();
    return allDoctors.where((doctor) {
      return doctor.name.toLowerCase().contains(lowerSearch) ||
          doctor.specialization.toLowerCase().contains(lowerSearch);
    }).toList();
  }

  /// Update doctor profile (for completing profile setup)
  Future<void> updateDoctorProfile(String doctorId, Map<String, dynamic> data) async {
    await _firestore.collection('doctors').doc(doctorId).update(data);
  }

  // ==================== Appointments ====================

  /// Create a new appointment
  Future<String> createAppointment(AppointmentModel appointment) async {
    final docRef = await _firestore
        .collection('appointments')
        .add(appointment.toMap());
    return docRef.id;
  }

  /// Get appointments for a patient
  Future<List<AppointmentModel>> getPatientAppointments(String patientId) async {
    final query = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .orderBy('dateTime', descending: true)
        .get();
    return query.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Get appointments for a doctor
  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    final query = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('dateTime', descending: true)
        .get();
    return query.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Get upcoming appointments for a patient (future + confirmed/pending)
  Future<List<AppointmentModel>> getUpcomingAppointments(String patientId) async {
    final now = DateTime.now().toIso8601String();
    final query = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where('dateTime', isGreaterThanOrEqualTo: now)
        .orderBy('dateTime')
        .get();
    return query.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .where((apt) =>
            apt.status == AppointmentStatus.pending ||
            apt.status == AppointmentStatus.confirmed)
        .toList();
  }

  /// Get pending appointments for a doctor (for accept/reject)
  Future<List<AppointmentModel>> getPendingDoctorAppointments(
    String doctorId,
  ) async {
    final query = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'pending')
        .get();
    return query.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Update appointment status (confirm, reject, cancel, complete)
  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': status.name,
    });
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
  }

  /// Get booked time slots for a doctor on a specific date
  Future<List<String>> getBookedSlots(String doctorId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('dateTime', isLessThan: endOfDay.toIso8601String())
        .get();

    return query.docs
        .map((doc) => doc.data()['timeSlot'] as String)
        .where((slot) {
          final status = query.docs
              .firstWhere((d) => d.data()['timeSlot'] == slot)
              .data()['status'];
          return status != 'cancelled';
        })
        .toList();
  }

  // ==================== All Appointments (Admin) ====================

  Future<List<AppointmentModel>> getAllAppointments() async {
    final query = await _firestore
        .collection('appointments')
        .orderBy('dateTime', descending: true)
        .get();
    return query.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ==================== All Doctors (Admin) ====================

  Future<List<DoctorModel>> getAllDoctors() async {
    final query = await _firestore.collection('doctors').get();
    return query.docs
        .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Approve or reject a doctor
  Future<void> approveDoctorProfile(String doctorId, bool approve) async {
    await _firestore.collection('doctors').doc(doctorId).update({
      'isApproved': approve,
    });
  }
}
