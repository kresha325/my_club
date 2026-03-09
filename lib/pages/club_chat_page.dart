import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/dependencies.dart';
import '../models/announcement.dart';
import '../utils/app_localizations.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class _MemberSession {
  const _MemberSession({required this.uid, required this.fullName});

  final String uid;
  final String? fullName;
}

class ClubChatPage extends StatefulWidget {
  const ClubChatPage({super.key});

  @override
  State<ClubChatPage> createState() => _ClubChatPageState();
}

class _ClubChatPageState extends State<ClubChatPage> {
  Future<_MemberSession?>? _memberFuture;
  bool _promptOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _memberFuture ??= _prepareMemberSession();
  }

  Future<_MemberSession?> _prepareMemberSession() async {
    final deps = DependenciesScope.of(context);
    try {
      final user = await deps.authService.ensureMemberUser();
      final uid = user?.uid;
      if (uid == null) return null;
      final fullName = await deps.memberProfilesRepository.getFullName(uid);
      return _MemberSession(uid: uid, fullName: fullName);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _ensureFullName({required String uid}) async {
    if (_promptOpen) return false;

    _promptOpen = true;
    final controller = TextEditingController();
    final deps = DependenciesScope.of(context);
    try {
      final value = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          String tr(String key) => AppLocalizations.t(context, key);

          return AlertDialog(
            title: Text(tr('fullNamePromptTitle')),
            content: TextField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: tr('fullName'),
                hintText: tr('fullNameHint'),
              ),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(tr('later')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(controller.text),
                child: Text(tr('save')),
              ),
            ],
          );
        },
      );

      final fullName = value?.trim() ?? '';
      if (fullName.isEmpty) return false;

      await deps.memberProfilesRepository.saveFullName(
        uid: uid,
        fullName: fullName,
      );

      if (mounted) {
        setState(() {
          _memberFuture = Future.value(
            _MemberSession(uid: uid, fullName: fullName),
          );
        });
      }
      return true;
    } finally {
      _promptOpen = false;
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    String tr(String key) => AppLocalizations.t(context, key);

    return Column(
      children: [
        SectionHeader(title: tr('clubChat')),
        Expanded(
          child: FutureBuilder<_MemberSession?>(
            future: _memberFuture,
            builder: (context, sessionSnapshot) {
              final session = sessionSnapshot.data;
              return StreamBuilder<List<Announcement>>(
                stream: deps.announcementsRepository.streamLatest(limit: 200),
                builder: (context, snapshot) {
                  final items = snapshot.data ?? const <Announcement>[];
                  if (items.isEmpty) {
                    return EmptyState(
                      title: tr('chatNoMessages'),
                      subtitle: tr('chatNoMessagesSubtitle'),
                      icon: Icons.forum_outlined,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _AnnouncementCard(
                        tr: tr,
                        announcement: item,
                        session: session,
                        onRequireFullName: _ensureFullName,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.tr,
    required this.announcement,
    required this.session,
    required this.onRequireFullName,
  });

  final String Function(String key) tr;
  final Announcement announcement;
  final _MemberSession? session;
  final Future<bool> Function({required String uid}) onRequireFullName;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 560),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title.isEmpty
                          ? tr('chatAdmin')
                          : announcement.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(announcement.message),
                    const SizedBox(height: 8),
                    Text(
                      _metaLine(context, announcement),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            if (announcement.requiresParticipation) ...[
              const SizedBox(height: 8),
              StreamBuilder<AnnouncementResponse?>(
                stream: session == null
                    ? null
                    : deps.announcementsRepository.streamUserResponse(
                        announcementId: announcement.id,
                        uid: session!.uid,
                      ),
                builder: (context, snapshot) {
                  final choice = snapshot.data?.choice;

                  Future<void> submitChoice(ParticipationChoice value) async {
                    final member = session;
                    if (member == null) return;

                    var fullName = member.fullName?.trim() ?? '';
                    if (fullName.isEmpty) {
                      final ok = await onRequireFullName(uid: member.uid);
                      if (!ok || !context.mounted) return;
                      final refreshed = await deps.memberProfilesRepository
                          .getFullName(member.uid);
                      fullName = refreshed?.trim() ?? '';
                      if (fullName.isEmpty) return;
                    }

                    await deps.announcementsRepository.setResponse(
                      announcementId: announcement.id,
                      response: AnnouncementResponse(
                        uid: member.uid,
                        displayName: fullName,
                        choice: value,
                        respondedAt: DateTime.now(),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          FilledButton.tonal(
                            onPressed: () =>
                                submitChoice(ParticipationChoice.yes),
                            child: Text(tr('iWillParticipate')),
                          ),
                          FilledButton.tonal(
                            onPressed: () =>
                                submitChoice(ParticipationChoice.no),
                            child: Text(tr('iWillNotParticipate')),
                          ),
                        ],
                      ),
                      if (choice != null) ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 360),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              choice == ParticipationChoice.yes
                                  ? tr('meWillParticipate')
                                  : tr('meWillNotParticipate'),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _metaLine(BuildContext context, Announcement item) {
    final fmt = DateFormat.yMMMd().add_Hm();
    final created = item.createdAt == null
        ? ''
        : fmt.format(item.createdAt!.toLocal());
    final starts = item.startsAt == null
        ? ''
        : fmt.format(item.startsAt!.toLocal());
    final publishedLabel = AppLocalizations.t(context, 'published');
    final startsLabel = AppLocalizations.t(context, 'starts');

    if (created.isNotEmpty && starts.isNotEmpty) {
      return '$publishedLabel: $created | $startsLabel: $starts';
    }
    if (starts.isNotEmpty) return '$startsLabel: $starts';
    if (created.isNotEmpty) return '$publishedLabel: $created';
    return '';
  }
}
