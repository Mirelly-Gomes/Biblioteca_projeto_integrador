import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(
          BaseOptions(
            baseUrl: "https://bibliotecabackend.gigalixirapp.com/api",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {"Content-Type": "application/json"},
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  // LOGIN
  Future<Response> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      if (response.data != null && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
      }

      return response;
    } on DioException catch (e) {
      throw Exception('Erro ao fazer login: ${e.message}');
    }
  }

  // REGISTER (precisa estar logado como admin)
  Future<Response> register(String email, String password, String role) async {
    try {
      final response = await dio.post(
        '/auth/register',
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

  // GET todos os livros
  Future<List<dynamic>> getLivros() async {
    try {
      final response = await dio.get('/books');
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception('Erro ao buscar livros: ${e.message}');
    }
  }

  // GET livro por ID
  Future<Map<String, dynamic>> getLivroById(String id) async {
    try {
      final response = await dio.get('/books/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar livro $id: ${e.message}');
    }
  }

  // ADD livro
  Future<Map<String, dynamic>> addLivro(Map<String, dynamic> livro) async {
    try {
      final response = await dio.post('/books', data: livro);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao adicionar livro: ${e.message}');
    }
  }

  // UPDATE livro
  Future<Map<String, dynamic>> updateLivro(String id, Map<String, dynamic> livro) async {
    try {
      final response = await dio.put('/books/$id', data: livro);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar livro $id: ${e.message}');
    }
  }

  // DELETE livro
  Future<void> deleteLivro(String id) async {
    try {
      await dio.delete('/books/$id');
    } on DioException catch (e) {
      throw Exception('Erro ao deletar livro $id: ${e.message}');
    }
  }
}
