class Transaction {
  final int? id;
  final int userId;
  final int bookId;
  final String tglPinjam;
  final int durasiPinjam;
  final int totalBiaya;
  final String status;

  Transaction({
    required this.id, 
    required this.userId, 
    required this.bookId, 
    required this.tglPinjam, 
    required this.durasiPinjam, 
    required this.totalBiaya, 
    required this.status
    });

     Transaction copyWith({
    int? id,
    int? userId,
    int? bookId,
    String? loanDate,
    int? loanDuration,
    int? totalCost,
    String? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      tglPinjam: tglPinjam ?? this.tglPinjam,
      durasiPinjam: durasiPinjam ?? this.durasiPinjam,
      totalBiaya: totalBiaya ?? this.totalBiaya,
      status: status ?? this.status,
    );
}

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'tgl_pinjam': tglPinjam,
      'durasi_pinjam': durasiPinjam,
      'total_biaya': totalBiaya,
      'status': status,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] != null ? map['id'] as int : null, 
      userId: map['user_id'] as int, 
      bookId: map['book_id'] as int, 
      tglPinjam: map['tgl_pinjam'] as String, 
      durasiPinjam: map['durasi_pinjam'] as int, 
      totalBiaya: map['total_biaya'] as int, 
      status: map['status'] as String,
      );
  }
}