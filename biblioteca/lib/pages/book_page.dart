import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  static const String route = "/book";
  final Map<String, dynamic> book;
  const BookPage({super.key, required this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book["title"]);
    _authorController = TextEditingController(text: widget.book["author"]);
    _descriptionController = TextEditingController(text: widget.book["description"]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Atualiza os valores no livro
    widget.book["title"] = _titleController.text;
    widget.book["author"] = _authorController.text;
    widget.book["description"] = _descriptionController.text;

    // Fecha a página retornando o livro atualizado
    Navigator.pop(context, widget.book);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F4FF),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Text(
          "Gerenciador de livros",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.indigo),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
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
                    // Título
                    _isEditing
                        ? TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: "Título",
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.black),
                          )
                        : (book["title"] != null && book["title"].toString().isNotEmpty)
                            ? Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Título: ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: book["title"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                    const SizedBox(height: 8),
                    // Autor
                    _isEditing
                        ? TextField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: "Autor",
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.black),
                          )
                        : (book["author"] != null && book["author"].toString().isNotEmpty)
                            ? Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Autor: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: book["author"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                    const SizedBox(height: 20),
                    // Descrição
                    _isEditing
                        ? TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: "Descrição",
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            style: const TextStyle(color: Colors.black),
                          )
                        : (book["description"] != null && book["description"].toString().isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Descrição",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    book["description"],
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                    const SizedBox(height: 20),
                    // Botão menor centralizado
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.3,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isEditing) {
                              _saveChanges(); // salva e volta para Home
                            } else {
                              setState(() {
                                _isEditing = true; // apenas ativa edição
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40B8FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _isEditing ? "Salvar" : "Editar",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
