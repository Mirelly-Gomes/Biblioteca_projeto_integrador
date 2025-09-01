import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/auth_repository.dart';
import 'add_book_page.dart';
import 'book_page.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  static const route = '/home';
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = BookRepository();
  final searchCtrl = TextEditingController();
  List<Book> books = [];
  bool loading = true;
  String role = 'user';

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      role = prefs.getString('role') ?? 'user';
      if (searchCtrl.text.trim().isEmpty) {
        books = await repo.list();
      } else {
        books = await repo.search(searchCtrl.text.trim());
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Minha Livraria'),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, HomePage.route),
              icon: const Icon(Icons.people_alt),
              tooltip: 'Usuários',
            ),
          IconButton(
            onPressed: () async {
              await AuthRepository().logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, LoginPage.route);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: 'Buscar livros...',
                filled: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _load,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : books.isEmpty
                  ? const Center(child: Text('Nenhum livro encontrado'))
                  : ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (ctx, i) {
                        final b = books[i];
                        return Card(
                          color: const Color(0xFF2E2E3A),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  b.coverUrl != null && b.coverUrl!.isNotEmpty
                                  ? Image.network(
                                      b.coverUrl!,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    )
                                  : const Icon(Icons.menu_book),
                            ),
                            title: Text(b.title),
                            subtitle: Text('Autor: ${b.author}'),
                            onTap: () => Navigator.pushNamed(
                              context,
                              BookPage.route,
                              arguments: b.id,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.pushNamed(context, AddBookPage.route);
                _load();
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Livro'),
            )
          : null,
    );
  }
}
