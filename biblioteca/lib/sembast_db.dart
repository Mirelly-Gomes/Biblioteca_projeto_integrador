import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';


class SembastDb {
  SembastDb._internal();
  static final SembastDb _instance = SembastDb._internal();
  factory SembastDb() => _instance;

  late Database _db;
  final _store = intMapStoreFactory.store("books");

  Future<void> initDb() async {
    if (kIsWeb) {
      _db = await databaseFactoryWeb.openDatabase('books.db');
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'books.db');
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  Future<int> addBook({
    required String title,
    required String author,
    required int pages,
    required String description,
    required String image,
  }) async {
    Map<String, dynamic> book = {
      'title': title,
      'author': author,
      'pages': pages,
      'description': description,
      'image': image
    };

    return await _store.add(_db, book);
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final snapshot = await _store.find(_db);
    return snapshot.map((element) {
      final data = Map<String, dynamic>.from(element.value);
      data['id'] = element.key;
      return data;
    }).toList();
  }

  Future<void> deleteBook(int id) async {
    await _store.record(id).delete(_db);
  }

  Future<void> deleteAllBook() async {
    await _store.delete(_db);
  }
}

