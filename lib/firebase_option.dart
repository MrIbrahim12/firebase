// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
    //...
      case TargetPlatform.fuchsia:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TargetPlatform.iOS:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TargetPlatform.linux:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TargetPlatform.macOS:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TargetPlatform.windows:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR-KEY',
    appId: 'YOUR-APP-ID',
    messagingSenderId: 'SENDER-ID',
    projectId: 'PROJECT-ID',
    //...
  );
}
