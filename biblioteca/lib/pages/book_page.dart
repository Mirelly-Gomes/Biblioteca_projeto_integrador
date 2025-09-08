import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book["title"]);
    _authorController = TextEditingController(text: widget.book["author"]);
    _descriptionController = TextEditingController(
      text: widget.book["description"],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final updatedBook = {
        "title": _titleController.text,
        "author": _authorController.text,
        "description": _descriptionController.text,
      };

      await _apiService.updateLivro(widget.book["id"].toString(), updatedBook);

      Navigator.pop(context, updatedBook);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: $e")),
      );
    }
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
          "Detalhes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.indigo),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              width: screenWidth * 0.4,
              height: screenHeight * 0.65,
              color: Colors.grey.shade300,
              child: book["cover_url"] != null &&
                      book["cover_url"].toString().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(book["cover_url"], fit: BoxFit.cover),
                    )
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isEditing
                        ? TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: "Título",
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text.rich(
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
                                  text: book["title"] ?? "",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: "Autor",
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text.rich(
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
                                  text: book["author"] ?? "",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 20),
                    _isEditing
                        ? TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: "Descrição",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                          )
                        : Column(
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
                                book["description"] ?? "",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.3,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isEditing) {
                              _saveChanges();
                            } else {
                              setState(() => _isEditing = true);
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
