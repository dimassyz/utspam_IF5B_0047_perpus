import '../db/db_helper.dart';
import '../model/user.dart';

class AuthRepository {
  final DbHelper _dbHelper = DbHelper();

// Register
  Future<int> registerUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

// Login
  Future<User?> loginUser(String identifier, String password) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: '(email = ? OR nik = ?) AND password = ?',
      whereArgs: [identifier, identifier, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }
}