import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String dbName = "perpustakaan.db";

  DbHelper._init();
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  factory DbHelper() {
    return instance;
  }

  Future<Database> get database async {
    _database = await _initDatabase(dbName);
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_lengkap TEXT NOT NULL,
      nik TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      alamat TEXT NOT NULL,
      telp TEXT NOT NULL,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');

    await db.execute(''' 
    CREATE TABLE books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT NOT NULL,
      genre TEXT NOT NULL,
      harga_rental INTEGER NOT NULL,
      cover_path TEXT NOT NULL,
      sinopsis TEXT NOT NULL
    )
    ''');

    await db.execute(''' 
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      book_id INTEGER NOT NULL,
      tgl_pinjam TEXT NOT NULL,
      durasi_pinjam INTEGER NOT NULL,
      total_biaya INTEGER NOT NULL,
      status TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id),
      FOREIGN KEY (book_id) REFERENCES books (id)
    )
    ''');
    await _insertDummyData(db);
  }
  Future<void> _insertDummyData(Database db) async {
    List<Map<String, dynamic>> books = [
      {
        'judul': 'Novel 1984',
        'genre': 'Novel',
        'harga_rental': 30000,
        'cover_path': 'assets/images/1984.jpg',
        'sinopsis': 'Novel “1984” bercerita tentang suatu masa di sekitar tahun 1984. Orwell menggambarkan masa itu sebagai masa yang penuh penderitaan. Dalam semesta “1984”, dunia dibagi menjadi tiga poros kuasa; Oceania, Eurasia, dan Eastasia. Setiap negara dipimpin oleh satu partai. Mereka semua berhaluan sosialis. Setiap negara juga menerapkan sistem totalitarian. Novel ini fokus menceritakan Oceania, khususnya London dimana sang tokoh utama hidup. Oceania dipimpin oleh Big Brother (Bung Besar) yang wajahnya tertera di poster-poster di berbagai penjuru negara. Sistem kediktatoran yang diterapkan membuat semua warganya harus tunduk dan patuh. Kedisiplinan ini sifatnya menyeluruh. Mulai dari jadwal bangun tidur, hiburan, buku yang dibaca, bahkan ekspresi muka dan pikiran.'
      },
      {
        'judul': 'Animal Farm',
        'genre': 'Novel',
        'harga_rental': 35000,
        'cover_path': 'assets/images/animalfarm.jpg',
        'sinopsis': 'Dongeng tentang para penguasa ini merupakan satir yang menggambarkan bagaimana sifat asli manusia dan karakternya ketika memiliki kekuasaan yang besar. Sebagai cerita yang ditulis sejak 17 Agustus 1945 ini, kisahnya terus diceritakan di banyak negara dan bahasa selama lebih dari 70 tahun.'
      },
      {
        'judul': 'Don Quixote',
        'genre': 'Novel',
        'harga_rental': 25000,
        'cover_path': 'assets/images/donquixote.jpg',
        'sinopsis': 'Novel ini berkisah tentang sosok Alonso Quixando, seorang bangsawan Spanyol yang senang membaca kisah dongeng ksatria, sampai-sampai ia harus kehilangan akal dan mengidap halusinasi.'
      },
       {
        'judul': 'To Kill a Mockingbird',
        'genre': 'Novel',
        'harga_rental': 30000,
        'cover_path': 'assets/images/mockingbird.jpg',
        'sinopsis': 'To Kill a Mockingbird adalah novel klasik karya Harper Lee yang berlatar tahun 1930-an di Alabama dan mengisahkan tentang rasisme, ketidakadilan, dan prasangka'
      },
      {
        'judul': 'Di Tanah Lada',
        'genre': 'Novel',
        'harga_rental': 20000,
        'cover_path': 'assets/images/tanahlada.jpg',
        'sinopsis': 'Di Tanah Lada mengisahkan tentang Ava, seorang anak perempuan berusia 6 tahun yang tinggal bersama orang tua yang kasar dan sering mengalami kekerasan verbal maupun fisik dari ayahnya.'
      },
    ];
    for (var book in books) {
      await db.insert('books', book);
    }
  }
}