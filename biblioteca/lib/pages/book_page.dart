import 'package:biblioteca/pages/add_book.dart';
import 'package:flutter/material.dart';


class BookPage extends StatefulWidget {
  static const String route = "/book";
  final Map<String, dynamic> book;
  const BookPage({super.key, required this.book});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Livro")),
      body: Column(
        children: [
          Text(widget.book["title"]),
          Text(widget.book["author"]),
          Text(widget.book["description"]),
          Image.network(
            widget.book["image"],
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddBookPage.route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
