class Book {
  final int? id;
  final String judul;      
  final String genre;     
  final int hargaRental;  
  final String coverPath; 
  final String sinopsis; 

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
      judul: map['judul']?.toString() ?? 'Tanpa Judul',
      genre: map['genre']?.toString() ?? '',
      hargaRental: (map['harga_rental'] is int) 
          ? map['harga_rental'] 
          : int.tryParse(map['harga_rental'].toString()) ?? 0,
      coverPath: map['cover_path']?.toString() ?? '',
      sinopsis: map['sinopsis']?.toString() ?? '',
    );
  }
}