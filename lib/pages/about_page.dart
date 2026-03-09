import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';
import '../widgets/section_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        SectionHeader(title: tr('aboutTitle')),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('whoWeAre'), style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(tr('whoWeAreBody')),
                const SizedBox(height: 16),
                Text(tr('whatWeOffer'), style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(tr('whatWeOfferBody')),
                const SizedBox(height: 16),
                Text(tr('clubValues'), style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(tr('clubValuesBody')),
                const SizedBox(height: 16),
                Text(tr('contact'), style: textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text(
                  'Address: Prizren\n'
                  'Phone: +383 XX XXX XXX\n'
                  'Email: info@kolosi.club',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
