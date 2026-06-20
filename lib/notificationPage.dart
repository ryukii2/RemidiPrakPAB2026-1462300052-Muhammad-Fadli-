import 'package:flutter/material.dart';
import 'package:flutter_pertemuan1/api/apiController.dart';
import 'package:flutter_pertemuan1/api/Article.dart';
import 'package:flutter_pertemuan1/detailPage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Apicontroller apiController = Apicontroller();
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = apiController.getdatas();
  }

  String _timeAgo(String publishedAt) {
    try {
      final published = DateTime.parse(publishedAt);
      final diff = DateTime.now().difference(published);

      if (diff.inDays > 0) return '${diff.inDays} hari lalu';
      if (diff.inHours > 0) return '${diff.inHours} jam lalu';
      if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
      return 'Baru saja';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat notifikasi: ${snapshot.error}'));
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return const Center(child: Text('Belum ada notifikasi'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: articles.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.notifications, color: Colors.blue),
              ),
              title: Text(
                'Berita baru dari ${article.newsSite}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              subtitle: Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                _timeAgo(article.publishedAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(article: article)),
                );
              },
            );
          },
        );
      },
    );
  }
}