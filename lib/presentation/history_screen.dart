import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; 
import '../data/model/transaction.dart';
import '../data/model/book.dart';
import '../data/repository/transaction_repository.dart';
import '../data/repository/book_repository.dart';
import 'loan_detail_screen.dart'; 

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final TransactionRepository _transactionRepo = TransactionRepository();
  final BookRepository _bookRepo = BookRepository();

  Future<List<Transaction>>? _historyList;
  String _namaPeminjam = "";

  @override
  void initState() {
    super.initState();
    _loadSessionAndData();
  }

  // fungsi ambil id user
  Future<void> _loadSessionAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final String userName = prefs.getString('userName') ?? "User";

    if (!mounted) return;

    // fungsi ambil transaksi berdasarkan user id
    if (userId != null) {
      setState(() {
        _namaPeminjam = userName;
        _historyList = _transactionRepo.getTransactionsByUserId(userId);
      });
    } else {
      setState(() {
        _historyList = Future.value([]);
      });
    }
  }

  // format rp
  String _formatRupiah(int number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  // warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'AKTIF': return Colors.blue;
      case 'SELESAI': return Colors.green;
      case 'DIBATALKAN': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Riwayat Peminjaman"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _historyList == null
          ? const Center(child: CircularProgressIndicator())

          // 
          : FutureBuilder<List<Transaction>>(
              future: _historyList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                // fungsi untuk menampilkan list riwayat
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    return _buildTransactionCard(transaction);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Belum ada riwayat transaksi.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.add),
            label: const Text("Pinjam Buku Baru"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
          )
        ],
      ),
    );
  }


  Widget _buildTransactionCard(Transaction transaction) {
    return FutureBuilder<Book?>(
      future: _bookRepo.getBookById(transaction.bookId),
      builder: (context, bookSnapshot) {

        String judulBuku = "";
        String coverPath = ""; 
        
        if (bookSnapshot.hasData && bookSnapshot.data != null) {
          judulBuku = bookSnapshot.data!.judul;
          coverPath = bookSnapshot.data!.coverPath;
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanDetailScreen(
                    transaction: transaction, 
                    book: bookSnapshot.data!
                  )
                )
              ).then((_) {
                _loadSessionAndData();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // tampilkan cover buku
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: bookSnapshot.hasData
                        ? Image.asset(
                            coverPath,
                            width: 60, height: 90, fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: 60, height: 90, color: Colors.grey[200],
                              child: const Icon(Icons.menu_book, color: Colors.grey),
                            ),
                          )
                        : Container( 
                            width: 60, height: 90, color: Colors.grey[200],
                          ),
                  ),
                  
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // judul
                        Text(
                          judulBuku,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        
                        // nama peminjam
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _namaPeminjam,
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(transaction.status).withOpacity(0.1),
                            borderRadius: BorderRadius.vertical(),
                            border: Border.all(color: _getStatusColor(transaction.status).withOpacity(0.5)),
                          ),
                          child: Text(
                            transaction.status,
                            style: TextStyle(
                              fontSize: 10, 
                              color: _getStatusColor(transaction.status), 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // total biaya
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatRupiah(transaction.totalBiaya),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.tglPinjam,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}