import 'package:flutter/material.dart';
import 'package:flutter_pertemuan1/api/apiController.dart';

class FilmApiPage extends StatefulWidget {
  const FilmApiPage({super.key});

  @override
  State<FilmApiPage> createState() => _FilmApiPageState();
}

class _FilmApiPageState extends State<FilmApiPage> {
  List films = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDataFilm();
  }

  Future<void> getDataFilm() async {
    films = await Apicontroller().getdatas();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Studio Ghibli"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: films.length,
              itemBuilder: (context, index) {
                final film = films[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          film["image"],
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 300,
                              child: Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film["title"],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Director : ${film["director"]}",
                              style: const TextStyle(fontSize: 16),
                            ),

                            Text(
                              "Producer : ${film["producer"]}",
                              style: const TextStyle(fontSize: 16),
                            ),

                            Text(
                              "Release : ${film["release_date"]}",
                              style: const TextStyle(fontSize: 16),
                            ),

                            Text(
                              "Rating : ${film["rt_score"]}",
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              film["description"],
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}