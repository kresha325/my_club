import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SectionHeader(title: 'Membership'),
        Expanded(
          child: EmptyState(
            title: 'Membership placeholder',
            subtitle:
                'Monetization skeleton:\n'
                '• membership tiers\n'
                '• premium content\n'
                '• donations\n\n'
                'Admin/developer: connect payment provider and protect content with roles.',
            icon: Icons.card_membership_outlined,
          ),
        ),
      ],
    );
  }
}
