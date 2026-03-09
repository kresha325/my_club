import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';

class FirebaseSetupPage extends StatelessWidget {
  const FirebaseSetupPage({required this.error, super.key});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase setup required')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'This project is a Firebase-ready skeleton.\n\n'
            'To run it, connect a Firebase project and generate your '
            '`firebase_options.dart` using FlutterFire.',
          ),
          const SizedBox(height: 12),
          const Text('Next steps (recommended):'),
          const SizedBox(height: 8),
          const Text('1) Run: flutter pub get'),
          const Text('2) Run: flutterfire configure'),
          const Text(
            '3) Deploy Functions (optional): firebase deploy --only functions',
          ),
          const SizedBox(height: 16),
          if (error != null) ...[
            const Divider(),
            const SizedBox(height: 8),
            const Text('Init error (expected until configured):'),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
