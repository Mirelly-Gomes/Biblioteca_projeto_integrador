import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/add_book_page.dart';
import 'pages/book_page.dart';
import 'pages/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E2E3A),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (_) => const LoginPage(),
        RegisterPage.route: (_) => const RegisterPage(),
        HomePage.route: (_) => const HomePage(),
        AddBookPage.route: (_) => const AddBookPage(),
    
      },
      onGenerateRoute: (settings) {
        if (settings.name == BookPage.route) {
          final id = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => BookPage(bookId: id));
        }
        return null;
      },
    );
  }
}
