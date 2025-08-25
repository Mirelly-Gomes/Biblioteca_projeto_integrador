import 'package:biblioteca/pages/add_book.dart';
import 'package:flutter/material.dart';

// Página de detalhes do livro
class BookPage extends StatefulWidget {
  static const String route = "/book";
  final Map<String, dynamic> book;
  const BookPage({super.key, required this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Barra superior
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Text(
          "Gerenciador de livros",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // botão voltar
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.indigo),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      // Corpo da página
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capa do livro
            Container(
              margin: const EdgeInsets.all(12),
              width: screenWidth * 0.4,
              height: screenHeight * 0.65,
              color: Colors.grey.shade300,
              child: book["image"] != null && book["image"].toString().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book["image"],
                        fit: BoxFit.cover,
                      ),
                    )
                  : null,
            ),
            // Informações do livro
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // título
                    if (book["title"] != null && book["title"].toString().isNotEmpty)
                      Text(
                        "Titulo: ${book["title"]}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    // autor
                    if (book["author"] != null && book["author"].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Autor: ${book["author"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    // descrição
                    if (book["description"] != null && book["description"].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Descrição",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book["description"],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // botão para adicionar livro
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.indigo, width: 2),
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddBookPage.route);
        },
        child: const Icon(Icons.add, color: Colors.indigo),
      ),
    );
  }
}
