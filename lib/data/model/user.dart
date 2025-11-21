import 'dart:convert';

class User {
  final int? id;
  final String nik;
  final String namaLengkap;
  final String email;
  final String alamat;
  final String telp;
  final String username;
  final String password;

  User({
    required this.id, 
    required this.nik, 
    required this.namaLengkap, 
    required this.email, 
    required this.alamat, 
    required this.telp, 
    required this.username, 
    required this.password
    });

    Map<String, dynamic> toMap(){
      return {
        'id': id,
        'nik': nik,
        'nama_lengkap': namaLengkap,
        'email': email,
        'alamat': alamat,
        'telp': telp,
        'username': username,
        'password': password,
      };
    }

    factory User.fromMap(Map<String, dynamic> map) {
      return User(
        id: map['id'], 
        nik: map['nik'], 
        namaLengkap: map['nama_lengkap'], 
        email: map['email'], 
        alamat: map['alamat'], 
        telp: map['telp'], 
        username: map['username'], 
        password: map['password'],
        );
    }
}

