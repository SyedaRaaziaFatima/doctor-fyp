// File generated from google-services.json — Firebase configuration for DocCare
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web Firebase options not configured yet. '
        'Add a web app in Firebase Console to get web config.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows Firebase options not configured yet. '
          'Add a web app in Firebase Console for Windows support.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg8s2-ey-DdSf8HRw1C7CCrDxZ2DuYGDg',
    appId: '1:864055832880:android:2db67f94c3c01102fb58f5',
    messagingSenderId: '864055832880',
    projectId: 'doctor-fyp-dd8c2',
    storageBucket: 'doctor-fyp-dd8c2.firebasestorage.app',
  );
}
