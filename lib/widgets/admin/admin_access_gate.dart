import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../widgets/empty_state.dart';

class AdminAccessGate extends StatelessWidget {
  const AdminAccessGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final user = deps.authService.currentUser;
    if (user == null) {
      return const EmptyState(
        title: 'Sign-in required',
        subtitle: 'Please sign in as an admin.',
        icon: Icons.lock_outline,
      );
    }

    return FutureBuilder<bool>(
      future: deps.adminAccessService.isAdmin(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final isAdmin = snapshot.data ?? false;
        if (!isAdmin) {
          return const EmptyState(
            title: 'Access denied',
            subtitle:
                'This account is not marked as admin.\n\n'
                'Developer/admin: add a document at `admins/{uid}` in Firestore '
                'to allow access.',
            icon: Icons.admin_panel_settings_outlined,
          );
        }

        return child;
      },
    );
  }
}
