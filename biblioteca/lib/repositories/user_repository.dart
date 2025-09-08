import 'package:biblioteca/data/models/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _api = ApiService(); 

  // Listar todos os usuários
  Future<List<AppUser>> list() async {
    final res = await _api.dio.get('/users');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(AppUser.fromJson).toList();
  }

  // Buscar usuário por ID
  Future<AppUser> getById(String id) async {
    final res = await _api.dio.get('/users/$id');
    return AppUser.fromJson(res.data as Map<String, dynamic>);
  }

  // Atualizar usuário
  Future<AppUser> update(
    String id, {
    required String email,
    required String role,
  }) async {
    final res = await _api.dio.put(
      '/users/$id',
      data: {
        'user': {'email': email, 'role': role},
      },
    );
    return AppUser.fromJson(res.data as Map<String, dynamic>);
  }

  // Deletar usuário
  Future<void> delete(String id) async {
    await _api.dio.delete('/users/$id');
  }
}
