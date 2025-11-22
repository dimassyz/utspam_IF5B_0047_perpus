class User {
  final int? id;
  final String nik;
  final String namaLengkap; // Sesuai DB: nama_lengkap
  final String email;
  final String alamat;      // Sesuai DB: alamat
  final String telp;        // Sesuai DB: telp
  final String username;
  final String password;

  User({
    this.id,
    required this.nik,
    required this.namaLengkap,
    required this.email,
    required this.alamat,
    required this.telp,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'nama_lengkap': namaLengkap, // DB pakai underscore
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
      // PENGAMAN: Jika null, ganti jadi string kosong ''
      nik: map['nik']?.toString() ?? '',
      namaLengkap: map['nama_lengkap']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      alamat: map['alamat']?.toString() ?? '',
      telp: map['telp']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
    );
  }
}