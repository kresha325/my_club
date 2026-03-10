import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_localizations.dart';
import '../widgets/section_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String _phoneNumber = '+38349158322';
  static const String _emailAddress = 'sadikferati@hotmail.com';
  static final Uri _facebookUrl = Uri.parse(
    'https://www.facebook.com/kmkolosiprizren',
  );
  static final Uri _phoneUrl = Uri.parse('tel:+38349158322');
  static final Uri _emailUrl = Uri.parse('mailto:sadikferati@hotmail.com');
  static final Uri _whatsAppUrl = Uri.parse('https://wa.me/38349158322');

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.t(context, key);
    final textTheme = Theme.of(context).textTheme;

    void showComingSoon(String platform) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$platform link do te shtohet se shpejti.')),
      );
    }

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
                  'Phone: +38349158322\n'
                  'Email: sadikferati@hotmail.com',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final opened = await launchUrl(
                          _emailUrl,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!context.mounted || opened) return;
                        showComingSoon('Email');
                      },
                      icon: const Icon(Icons.email_outlined),
                      label: Text(_emailAddress),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final opened = await launchUrl(
                          _phoneUrl,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!context.mounted || opened) return;
                        showComingSoon('Phone');
                      },
                      icon: const Icon(Icons.phone_outlined),
                      label: Text(_phoneNumber),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final opened = await launchUrl(
                          _facebookUrl,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!context.mounted || opened) return;
                        showComingSoon('Facebook');
                      },
                      icon: const Icon(Icons.facebook),
                      label: const Text('Facebook'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => showComingSoon('Instagram'),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Instagram'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final opened = await launchUrl(
                          _whatsAppUrl,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!context.mounted || opened) return;
                        showComingSoon('WhatsApp');
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('WhatsApp'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
