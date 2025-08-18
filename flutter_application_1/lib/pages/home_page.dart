import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_book.dart';
import 'package:flutter_application_1/pages/book_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/sembast_db.dart';

class HomePage extends StatefulWidget {
  static const String route = "/home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SembastDb _sembastDb = SembastDb();
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBooks();
  }

  Future<void>loadBooks() async{
    final listBooks = await _sembastDb.getBooks();
    setState(() {
      books = listBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.route);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index]["title"]),
            subtitle: Text(books[index]["author"]),
            leading: Image.network(books[index]["image"]),
            trailing: IconButton(onPressed: () async {
             await _sembastDb.deleteBook(books[index]["id"]);
              setState((){
                loadBooks();  
              });
            }, icon: Icon(Icons.delete)),
            onTap: () {
              Navigator.pushNamed(
                context,
                BookPage.route,
                arguments: books[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddBookPage.route).then((value) => loadBooks());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}