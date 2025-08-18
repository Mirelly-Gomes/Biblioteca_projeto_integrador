
import 'package:flutter/material.dart';
import 'package:flutter_application_1/sembast_db.dart';

class AddBookPage extends StatefulWidget {
  static const String route = "/add_book";
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  final SembastDb _sembastDb = SembastDb();
  bool isSaving = false;

  Future<void> saveBook() async {
    setState(() {
      isSaving = true;
    });
    await _sembastDb.addBook(
      title: titleController.text,
      author: authorController.text,
      pages: int.tryParse(pagesController.text) ?? 0,
      description: descriptionController.text,
      image: imageController.text,
    );
    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Livro")),
      body: Column(
        children: [
          Text("Adicionar Livro"),
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: authorController,
            decoration: InputDecoration(labelText: "Autor"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Descrição"),
          ),
          TextField(
            controller: pagesController,
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(labelText: "Quantidade de páginas"),
          ),
          TextField(
            controller: imageController,
            decoration: InputDecoration(labelText: "Imagem"),
          ),
          ElevatedButton(
            onPressed: () {
              saveBook();
            },
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }
}
