import '../db/db_helper.dart';
import '../model/transaction.dart';

class TransactionRepository {
  final DbHelper _dbHelper = DbHelper();

  // fungsi insert transaksi ke database
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  // read history user
  Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC', 
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  // fungsi update transaksi
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}