import '../db/db_helper.dart';
import '../model/book.dart';

class BookRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<List<Book>> getAllBooks() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }
}