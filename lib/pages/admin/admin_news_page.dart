import 'package:flutter/material.dart';

import '../../app/dependencies.dart';
import '../../models/news_item.dart';
import '../../widgets/admin/admin_access_gate.dart';
import '../../widgets/admin/confirm_delete_dialog.dart';
import '../../widgets/admin/forms/news_form_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AdminNewsPage extends StatelessWidget {
  const AdminNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);

    return AdminAccessGate(
      child: Column(
        children: [
          SectionHeader(
            title: 'News',
            trailing: FilledButton.icon(
              onPressed: () async {
                final result = await showDialog<NewsItem>(
                  context: context,
                  builder: (_) => const NewsFormDialog(),
                );
                if (result == null) return;
                await deps.newsRepository.create(result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<NewsItem>>(
              stream: deps.newsRepository.streamLatest(limit: 100),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <NewsItem>[];
                if (items.isEmpty) {
                  return const EmptyState(
                    title: 'No news',
                    subtitle: 'Add news so the Home page can display it.',
                    icon: Icons.feed_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final news = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          news.title.isEmpty ? '(Empty title)' : news.title,
                        ),
                        subtitle: Text(
                          news.body.isEmpty
                              ? 'Body: (empty)'
                              : 'Body: ${news.body}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final result = await showDialog<NewsItem>(
                                  context: context,
                                  builder: (_) => NewsFormDialog(initial: news),
                                );
                                if (result == null) return;
                                await deps.newsRepository.update(result);
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  entityLabel: 'news "${news.title}"',
                                );
                                if (!confirmed) return;
                                await deps.newsRepository.delete(news.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
