import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://bibliotecabackend.gigalixirapp.com",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<List<dynamic>> getLivros() async {
    try {
      final response = await _dio.get('/livros');
      return response.data; // Já retorna uma lista
    } on DioException catch (e) {
      throw Exception('Erro ao buscar livros: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getLivroById(String id) async {
    try {
      final response = await _dio.get('/livros/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar livro $id: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> addLivro(Map<String, dynamic> livro) async {
    try {
      final response = await _dio.post('/livros', data: livro);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao adicionar livro: ${e.message}');
    }
  }
}
