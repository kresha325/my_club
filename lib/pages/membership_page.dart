import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('membership')),
        Expanded(
          child: EmptyState(
            title: tr('membershipPlaceholder'),
            subtitle: tr('membershipPlaceholderSubtitle'),
            icon: Icons.card_membership_outlined,
          ),
        ),
      ],
    );
  }
}
