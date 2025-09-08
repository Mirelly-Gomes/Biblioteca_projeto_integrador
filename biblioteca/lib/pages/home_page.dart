import '../services/api_service.dart';
import 'package:biblioteca/pages/add_book.dart';
import 'package:biblioteca/pages/book_page.dart';
import 'package:biblioteca/pages/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = "/home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final listBooks = await _apiService.getLivros();
      setState(() {
        books = List<Map<String, dynamic>>.from(listBooks);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar livros: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4FF),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text(
          "Gerenciador de livros",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, LoginPage.route),
            icon: const Icon(
              Icons.logout,
              color: Color.fromRGBO(13, 71, 161, 1),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int cross = 4;
            if (constraints.maxWidth < 480) {
              cross = 2;
            } else if (constraints.maxWidth < 820) {
              cross = 3;
            }

            return GridView.builder(
              itemCount: books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 36,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                final book = books[index];

                return GestureDetector(
                  onTap: () async {
                    final updatedBook = await Navigator.pushNamed(
                      context,
                      BookPage.route,
                      arguments: book,
                    );

                    if (updatedBook != null && updatedBook is Map) {
                      setState(() {
                        books[index] = Map<String, dynamic>.from(updatedBook);
                      });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey[300],
                            child:
                                (book["cover_url"] != null &&
                                        (book["cover_url"] as String)
                                            .isNotEmpty)
                                    ? Image.network(
                                      book["cover_url"],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            color: Colors.grey[300],
                                          ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (book["title"] ?? "Título").toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        (book["author"] ?? "Autor").toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                      IconButton(
                        tooltip: "Excluir",
                        onPressed: () async {
                          await _apiService.deleteLivro(book["id"].toString());
                          loadBooks();
                        },
                        icon: const Icon(Icons.delete, color: Colors.black),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 180,
        height: 45,
        child: ElevatedButton(
          onPressed:
              () => Navigator.pushNamed(
                context,
                AddBookPage.route,
              ).then((_) => loadBooks()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF40B8FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Adicionar Livro",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
