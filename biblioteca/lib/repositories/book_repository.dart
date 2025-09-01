import '../services/api_service.dart';

class BookRepository {
  final ApiService _api = ApiService();

  Future<List<dynamic>> getAllBooks() async => await _api.getLivros();

  Future<Map<String, dynamic>> addBook(Map<String, dynamic> book) async =>
      await _api.addLivro(book);

  Future<void> deleteBook(String id) async => await _api.deleteLivro(id);

  Future<Map<String, dynamic>> updateBook(String id, Map<String, dynamic> book) async =>
      await _api.updateLivro(id, book);

  Future<Map<String, dynamic>> getBookById(String id) async => await _api.getLivroById(id);
}
