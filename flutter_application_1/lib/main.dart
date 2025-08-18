import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_book.dart';
import 'package:flutter_application_1/pages/book_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/sembast_db.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await SembastDb().initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (context) => LoginPage(),
        HomePage.route: (context) => HomePage(),
        AddBookPage.route: (context) => AddBookPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == BookPage.route) {
          final book = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(builder: (context) => BookPage(book: book));
        }
        return null;
      },
    );
  }
}