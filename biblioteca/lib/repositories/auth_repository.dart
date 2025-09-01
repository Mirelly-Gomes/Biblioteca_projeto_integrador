import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';


class AuthRepository {
  final ApiService _api = ApiService();

  Future<void> login(String email, String password) async {
    final res = await _api.login(email, password);
    final data = res.data;
    final token = data['token'] ?? data['access_token'];
    final role = data['user']?['role'] ?? data['role'] ?? 'user';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token ?? '');
    await prefs.setString('role', role);
    await prefs.setString('email', email);
  }

  Future<void> register(String email, String password, String role) async {
    await _api.register(email, password, role);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('email');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
