import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Users ---

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

  // --- Patients ---

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

  // --- Doctors ---

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
}
