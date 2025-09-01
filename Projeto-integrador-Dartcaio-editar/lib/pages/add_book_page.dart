import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';

class AddBookPage extends StatefulWidget {
  static const route = '/add_book';
  const AddBookPage({super.key});
  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final title = TextEditingController();
  final author = TextEditingController();
  final synopsis = TextEditingController();
  final publisher = TextEditingController();
  final pages = TextEditingController();
  final coverUrl = TextEditingController();
  bool saving = false;

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      final book = Book(
        id: '0',
        title: title.text.trim(),
        author: author.text.trim(),
        synopsis: synopsis.text.trim().isEmpty ? null : synopsis.text.trim(),
        publisher: publisher.text.trim().isEmpty ? null : publisher.text.trim(),
        pages: int.tryParse(pages.text.trim()),
        coverUrl: coverUrl.text.trim().isEmpty ? null : coverUrl.text.trim(),
      );
      await BookRepository().create(book);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Livro adicionado!',
      );
      Navigator.pop(context);
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Erro: $e',
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  InputDecoration _dec(String label) =>
      InputDecoration(labelText: label, filled: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Livro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                TextField(controller: title, decoration: _dec('Título')),
                const SizedBox(height: 8),
                TextField(controller: author, decoration: _dec('Autor')),
                const SizedBox(height: 8),
                TextField(
                  controller: synopsis,
                  decoration: _dec('Sinopse'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(controller: publisher, decoration: _dec('Editora')),
                const SizedBox(height: 8),
                TextField(
                  controller: pages,
                  decoration: _dec('Páginas'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: coverUrl,
                  decoration: _dec('URL da Capa'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: saving ? null : _save,
                    icon: const Icon(Icons.save),
                    label: saving
                        ? const CircularProgressIndicator()
                        : const Text('Salvar'),
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
