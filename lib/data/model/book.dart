class Book {
  final int? id;
  final String judul;       // DB: judul
  final String genre;       // DB: genre
  final int hargaRental;    // DB: harga_rental
  final String coverPath;   // DB: cover_path
  final String sinopsis;    // DB: sinopsis

  Book({
    this.id,
    required this.judul,
    required this.genre,
    required this.hargaRental,
    required this.coverPath,
    required this.sinopsis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'genre': genre,
      'harga_rental': hargaRental,
      'cover_path': coverPath,
      'sinopsis': sinopsis,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      // PENGAMAN: Ambil 'judul', kalau null jadi 'Tanpa Judul'
      judul: map['judul']?.toString() ?? 'Tanpa Judul',
      genre: map['genre']?.toString() ?? '',
      
      // PENGAMAN INTEGER: Ambil 'harga_rental'
      hargaRental: (map['harga_rental'] is int) 
          ? map['harga_rental'] 
          : int.tryParse(map['harga_rental'].toString()) ?? 0,
          
      coverPath: map['cover_path']?.toString() ?? '',
      sinopsis: map['sinopsis']?.toString() ?? '',
    );
  }
}