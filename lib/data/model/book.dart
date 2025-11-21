import 'dart:convert';

class Book {
  final int? id;
  final String judul;
  final String genre;
  final String harga;
  final String coverPath;
  final String synopsis;

  Book({
    required this.id, 
    required this.judul, 
    required this.genre, 
    required this.harga, 
    required this.coverPath, 
    required this.synopsis
    });

    Map<String, dynamic> toMap(){
      return {
        'id': id,
        'judul': judul,
        'genre': genre,
        'harga': harga,
        'coverPath': coverPath,
        'synopsis': synopsis,
      };
    }

    factory Book.fromMap(Map<String, dynamic> map) {
      return Book(
        id: map['id'], 
        judul: map['judul'], 
        genre: map['genre'], 
        harga: map['harga'], 
        coverPath: map['coverPath'], 
        synopsis: map['synopsis'], 
        );
    }
  }

