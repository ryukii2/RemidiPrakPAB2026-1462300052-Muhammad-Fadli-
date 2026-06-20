import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pertemuan1/api/Article.dart';

class DetailPage extends StatefulWidget {
  final Article article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;
  bool isChecking = true;

  String get _favoriteDocId =>
      '${FirebaseAuth.instance.currentUser?.uid}_${widget.article.id}';

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(_favoriteDocId)
        .get();

    if (mounted) {
      setState(() {
        isFavorite = doc.exists;
        isChecking = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(_favoriteDocId);

    if (isFavorite) {
      // Hapus dari favorite
      await docRef.delete();
    } else {
      // Simpan ke favorite: ID dan judul artikel
      await docRef.set({
        'userId': user.uid,
        'articleId': widget.article.id,
        'title': widget.article.title,
        'imageUrl': widget.article.imageUrl,
        'newsSite': widget.article.newsSite,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }

    if (mounted) {
      setState(() => isFavorite = !isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          isChecking
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.newspaper, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        article.newsSite,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        article.publishedAt.split('T').first,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    article.summary,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}