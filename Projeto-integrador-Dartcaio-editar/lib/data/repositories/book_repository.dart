import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/book.dart';

class BookRepository {
 




  Future<List<Book>> list() async {
    final res = await _dio.get('/books');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Book.fromJson).toList();
  }

  Future<Book> getById(String id) async {
    final res = await _dio.get('/books/$id');
    return Book.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<Book>> search(String q) async {
    final res = await _dio.get('/books/search', queryParameters: {'q': q});
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Book.fromJson).toList();
  }

  Future<Book> create(Book book) async {
    final res = await _dio.post('/books', data: book.toBody());
    return Book.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Book> update(String id, Map<String, dynamic> patch) async {
    final res = await _dio.put('/books/$id', data: {'book': patch});
    return Book.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/books/$id');
  }
}