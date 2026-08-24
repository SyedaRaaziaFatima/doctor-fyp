class AppConstants {
  // App Info
  static const String appName = 'DocCare';
  static const String appTagline = 'Your Health, Our Priority';
  static const String appVersion = '1.0.0';

  // Roles
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleAdmin = 'admin';

  // Appointment Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Urgency Levels (Diagnostics)
  static const String urgencyLow = 'low';
  static const String urgencyMedium = 'medium';
  static const String urgencyHigh = 'high';

  // Medical Specializations
  static const List<String> specializations = [
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Orthopedic',
    'Gynecologist',
    'Pediatrician',
    'ENT Specialist',
    'Neurologist',
    'Ophthalmologist',
    'Dentist',
    'Psychiatrist',
    'Urologist',
    'Pulmonologist',
    'Gastroenterologist',
    'Endocrinologist',
  ];

  // Time Slots
  static const List<String> timeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  // Days of week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Body Areas for Symptom Checker
  static const List<String> bodyAreas = [
    'Head & Neck',
    'Chest',
    'Abdomen',
    'Back',
    'Arms & Hands',
    'Legs & Feet',
    'Skin',
    'General / Whole Body',
  ];

  // Blood Groups
  static const List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  // Medical Record Categories
  static const List<String> recordCategories = [
    'Lab Reports',
    'X-Rays',
    'Prescriptions',
    'Insurance',
    'Discharge Summary',
    'Vaccination',
    'Other',
  ];

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxReviewLength = 1000;

  // Pagination
  static const int pageSize = 20;
}
