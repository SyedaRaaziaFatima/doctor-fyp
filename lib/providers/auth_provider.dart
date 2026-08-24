import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import '../services/firestore_service.dart';

/// Authentication state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

/// Auth Notifier — Integrated with Firebase Auth & Firestore
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  AuthNotifier() : super(const AuthState()) {
    // Listen to Firebase Auth state changes
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        state = const AuthState();
      } else {
        await _fetchUserData(firebaseUser.uid);
      }
    });
  }

  /// Fetches the user model from Firestore based on the Firebase Auth UID
  Future<void> _fetchUserData(String uid) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _firestoreService.getUser(uid);
      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: 'User data not found in database.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Login with Firebase Auth
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email and password are required',
      );
      return false;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The authStateChanges listener will handle fetching the user data
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Login failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Register with Firebase Auth & Create Firestore Documents
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'All fields are required',
      );
      return false;
    }

    if (password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Password must be at least 6 characters',
      );
      return false;
    }

    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Failed to create user in Firebase Auth');
      }

      // 2. Create the base UserModel
      final newUser = UserModel(
        id: firebaseUser.uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );

      // 3. Save to Firestore 'users' collection
      await _firestoreService.createUser(newUser);

      // 4. If Doctor or Patient, create their specific profile collections
      if (role == UserRole.doctor) {
        final doctor = DoctorModel(
          id: 'doc_${firebaseUser.uid}',
          userId: firebaseUser.uid,
          name: name,
          email: email,
          phone: phone,
          specialization: '', // To be filled later in profile setup
          experienceYears: 0,
          bio: '',
          consultationFee: 0,
          isApproved: false, // Requires admin approval
        );
        await _firestoreService.createDoctorProfile(doctor);
      } else if (role == UserRole.patient) {
        final patient = PatientModel(
          id: 'pat_${firebaseUser.uid}',
          userId: firebaseUser.uid,
          name: name,
          email: email,
          phone: phone,
        );
        await _firestoreService.createPatientProfile(patient);
      }

      // The authStateChanges listener will handle fetching the user data
      // but since we just created it, we know it's successful.
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Registration failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Forgot password via Firebase Auth
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    if (email.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email is required',
      );
      return false;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Failed to send reset email',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    // authStateChanges listener will reset the state
  }
}

/// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
