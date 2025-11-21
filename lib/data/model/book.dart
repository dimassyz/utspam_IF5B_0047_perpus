import 'dart:convert';

class Book {
  final int? id;
  final String judul;
  final String genre;
  final String harga;
  final String coverPath;
  final String sinopsis;

  Book({
    required this.id, 
    required this.judul, 
    required this.genre, 
    required this.harga, 
    required this.coverPath, 
    required this.sinopsis
    });

    Map<String, dynamic> toMap(){
      return {
        'id': id,
        'judul': judul,
        'genre': genre,
        'harga_rental': harga,
        'cover_path': coverPath,
        'sinopsis': sinopsis,
      };
    }

    factory Book.fromMap(Map<String, dynamic> map) {
      return Book(
        id: map['id'], 
        judul: map['judul'], 
        genre: map['genre'], 
        harga: map['harga_rental'], 
        coverPath: map['cover_path'], 
        sinopsis: map['sinopsis'], 
        );
    }
  }

