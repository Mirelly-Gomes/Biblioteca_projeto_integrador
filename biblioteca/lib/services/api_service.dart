import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://bibliotecabackend.gigalixirapp.com/api",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Content-Type": "application/json"},
    ),
  );

 Dio get dio => _dio;
  // LOGIN - envia email e senha
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao fazer login: ${e.message}');
    }
  }

  // GET todos os livros
  Future<List<dynamic>> getLivros() async {
    try {
      final response = await _dio.get('/books');
      return response.data['data'];

    } on DioException catch (e) {
      throw Exception('Erro ao buscar livros: ${e.message}');
    }
  }

  // ADD livro
  Future<Map<String, dynamic>> addLivro(Map<String, dynamic> livro) async {
    try {
      final response = await _dio.post('/books', data: livro);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao adicionar livro: ${e.message}');
    }
  }

  // DELETE livro
  Future<void> deleteLivro(String id) async {
    try {
      await _dio.delete('/livros/$id');
    } on DioException catch (e) {
      throw Exception('Erro ao deletar livro $id: ${e.message}');
    }
  }

  // GET livro por ID
  Future<Map<String, dynamic>> getLivroById(String id) async {
    try {
      final response = await _dio.get('/books/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar livro $id: ${e.message}');
    }
  }

  // UPDATE livro
  Future<Map<String, dynamic>> updateLivro(String id, Map<String, dynamic> livro) async {
    try {
      final response = await _dio.put('/books/$id', data: livro);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar livro $id: ${e.message}');
    }
  }

  // cadastro 
  Future<Response> register(String email, String password, String role) async {
  try {
    final response = await _dio.post(
      '/register',
      data: {
        "email": email,
        "password": password,
        "role": role,
      },
    );
    return response;
  } on DioException catch (e) {
    throw Exception('Erro ao registrar: ${e.message}');
  }
}
}
