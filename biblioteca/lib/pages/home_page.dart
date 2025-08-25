import 'package:biblioteca/pages/add_book.dart';
import 'package:biblioteca/pages/book_page.dart';
import 'package:biblioteca/pages/login_page.dart';
import 'package:biblioteca/sembast_db.dart';
import 'package:flutter/material.dart';

// Página inicial que lista os livros
class HomePage extends StatefulWidget {
  static const String route = "/home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SembastDb _sembastDb = SembastDb(); // banco de dados local
  List<Map<String, dynamic>> books = []; // lista de livros

  @override
  void initState() {
    super.initState();
    loadBooks(); // carrega os livros ao iniciar
  }

  // Função que busca os livros no banco
  Future<void> loadBooks() async {
    final listBooks = await _sembastDb.getBooks();
    setState(() {
      books = listBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text(
          "Gerenciador\nde livros",
          style: TextStyle(
            color: Color.fromRGBO(26, 0, 217, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // botão de logout
          IconButton(
            onPressed: () => Navigator.pushNamed(context, LoginPage.route),
            icon: const Icon(
              Icons.logout,
              color: Color.fromRGBO(13, 71, 161, 1),
            ),
          ),
        ],
      ),
      // Corpo com grid de livros
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int cross = 4; // padrão 4 colunas
            if (constraints.maxWidth < 480)
              cross = 2;
            else if (constraints.maxWidth < 820)
              cross = 3;

            return GridView.builder(
              itemCount: books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 36,
                mainAxisSpacing: 40,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                final book = books[index];

                return GestureDetector(
                  // abre detalhes do livro
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        BookPage.route,
                        arguments: book,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // capa do livro
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey[300],
                            child:
                                (book["image"] != null &&
                                        (book["image"] as String).isNotEmpty)
                                    ? Image.network(
                                      book["image"],
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
                      // título
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
                      // autor
                      Text(
                        (book["author"] ?? "Autor").toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                      // botão excluir
                      IconButton(
                        tooltip: "Excluir",
                        onPressed: () async {
                          await _sembastDb.deleteBook(book["id"]);
                          loadBooks(); // recarrega lista
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
      // botão para adicionar novo livro
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.pushNamed(
              context,
              AddBookPage.route,
            ).then((_) => loadBooks()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
