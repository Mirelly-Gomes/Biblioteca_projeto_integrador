import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';

class BookPage extends StatefulWidget {
  static const route = '/book';
  final String bookId;
  const BookPage({super.key, required this.bookId});
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Book? book;
  bool loading = true;
  bool editing = false;
  final title = TextEditingController();
  final author = TextEditingController();
  final synopsis = TextEditingController();
  final publisher = TextEditingController();
  final pages = TextEditingController();
  final coverUrl = TextEditingController();
  String role = 'user';

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      role = prefs.getString('role') ?? 'user';
      book = await BookRepository().getById(widget.bookId);
      title.text = book!.title;
      author.text = book!.author;
      synopsis.text = book!.synopsis ?? '';
      publisher.text = book!.publisher ?? '';
      pages.text = (book!.pages ?? '').toString();
      coverUrl.text = book!.coverUrl ?? '';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    try {
      final patch = <String, dynamic>{};
      if (title.text.trim().isNotEmpty) patch['title'] = title.text.trim();
      if (author.text.trim().isNotEmpty) patch['author'] = author.text.trim();
      patch['synopsis'] = synopsis.text.trim();
      patch['publisher'] = publisher.text.trim();
      final p = int.tryParse(pages.text.trim());
      if (p != null) patch['pages'] = p;
      patch['cover_url'] = coverUrl.text.trim();

      final updated = await BookRepository().update(widget.bookId, patch);
      setState(() => book = updated);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Salvo',
      );
      setState(() => editing = false);
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Erro: $e',
      );
    }
  }

  Future<void> _delete() async {
    try {
      await BookRepository().delete(widget.bookId);
      if (!mounted) return;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Excluído',
      );
      Navigator.pop(context);
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Erro: $e',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Widget _view() {
    final b = book!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if ((b.coverUrl ?? '').isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              b.coverUrl!,
              width: 180,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 96),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          b.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Autor: ${b.author}',
          style: const TextStyle(color: Color(0xFFB39DDB)),
        ),
        const SizedBox(height: 12),
        if ((b.publisher ?? '').isNotEmpty) Text('Editora: ${b.publisher}'),
        if (b.pages != null) Text('Páginas: ${b.pages}'),
        const SizedBox(height: 16),
        if ((b.synopsis ?? '').isNotEmpty)
          Text(b.synopsis!, textAlign: TextAlign.justify),
      ],
    );
  }

  InputDecoration _dec(String l) => InputDecoration(labelText: l, filled: true);

  Widget _edit() {
    return Column(
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
        TextField(controller: coverUrl, decoration: _dec('URL da capa')),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => editing = false),
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
        actions: [
          if (isAdmin && !loading && book != null)
            IconButton(
              onPressed: () => setState(() => editing = !editing),
              icon: Icon(editing ? Icons.visibility : Icons.edit),
            ),
          if (isAdmin && !loading && book != null)
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E3A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: editing ? _edit() : _view(),
                ),
              ),
            ),
    );
  }
}
