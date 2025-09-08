import '../services/api_service.dart';
import 'package:biblioteca/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AddBookPage extends StatefulWidget {
  static const String route = "/add_book";
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final ApiService _apiService = ApiService(); // usa ApiService
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  bool isSaving = false;

  Future<void> saveBook() async {
    if (titleController.text.isEmpty || authorController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Preencha o título e o autor!",
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await _apiService.addLivro({
        "title": titleController.text,
        "author": authorController.text,
        "description": descriptionController.text,
        "image": imageController.text,
        "pages": int.tryParse(pagesController.text) ?? 0,
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Livro adicionado com sucesso!",
        onConfirmBtnTap: () {
          Navigator.pushReplacementNamed(context, "/home");
        },
      );

      titleController.clear();
      authorController.clear();
      descriptionController.clear();
      imageController.clear();
      pagesController.clear();
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Erro ao adicionar livro: $e",
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF1E1EB8)),
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF40B8FF),
        elevation: 0,
        title: const Text(
          "Gerenciador de livros",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, LoginPage.route),
              icon: const Icon(
                Icons.logout,
                color: Color.fromRGBO(13, 71, 161, 1),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            width: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Adicionar Livro",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1EB8),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: inputStyle("Título"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authorController,
                  decoration: inputStyle("Autor"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: inputStyle("Descrição"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pagesController,
                  keyboardType: TextInputType.number,
                  decoration: inputStyle("Quantidade de páginas"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: inputStyle("Imagem"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSaving ? null : saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40B8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    "Adicionar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
