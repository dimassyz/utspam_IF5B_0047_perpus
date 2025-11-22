import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../data/model/transaction.dart';
import '../data/model/book.dart';
import '../data/repository/transaction_repository.dart';

class LoanDetailScreen extends StatefulWidget {
  final Transaction transaction;
  final Book book;

  const LoanDetailScreen({
    super.key, 
    required this.transaction, 
    required this.book
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  final TransactionRepository _transactionRepo = TransactionRepository();

  late Transaction _currentTransaction;
  String _namaPeminjam = "";

  @override
  void initState() {
    super.initState();
    _currentTransaction = widget.transaction;
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaPeminjam = prefs.getString('userName') ?? "User";
    });
  }

  // format rp
  String _formatRupiah(int number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  // status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'AKTIF': return Colors.blue;
      case 'SELESAI': return Colors.green;
      case 'DIBATALKAN': return Colors.red;
      default: return Colors.grey;
    }
  }

  // fungsi cancel
  void _handleCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Batalkan Peminjaman"),
        content: const Text("Apakah anda yakin ingin membatalkan transaksi ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Tidak")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
            
              final updatedTransaction = _currentTransaction.copyWith(
                status: 'DIBATALKAN'
              );
              await _transactionRepo.updateTransaction(updatedTransaction);

              setState(() {
                _currentTransaction = updatedTransaction;
              });

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Transaksi berhasil dibatalkan")),
              );
            },
            child: const Text("Ya, Batalkan", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // fungsi edit
  void _handleEdit() async {

    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("blm dibuat")),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    bool isAktif = _currentTransaction.status == 'AKTIF';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Detail Peminjaman"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.book.coverPath,
                        width: 100, height: 150, fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(width: 100, height: 150, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.book.genre, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          widget.book.judul,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
 
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_currentTransaction.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getStatusColor(_currentTransaction.status)),
                          ),
                          child: Text(
                            _currentTransaction.status,
                            style: TextStyle(
                              color: _getStatusColor(_currentTransaction.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.person, "Peminjam", _namaPeminjam), 
                  const Divider(),
                  _buildDetailRow(Icons.calendar_today, "Tanggal Mulai", _currentTransaction.tglPinjam), 
                  const Divider(),
                  _buildDetailRow(Icons.timer, "Lama Pinjam", "${_currentTransaction.durasiPinjam} Hari"),
                  const Divider(),
                  _buildDetailRow(Icons.monetization_on, "Total Biaya", _formatRupiah(_currentTransaction.totalBiaya), isBold: true), // Req a.vi
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (isAktif)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
  
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _handleEdit,
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Pesanan"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue[800],
                          side: BorderSide(color: Colors.blue.shade800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _handleCancel,
                        icon: const Icon(Icons.cancel),
                        label: const Text("Batalkan Peminjaman"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (!isAktif)
              Center(
                child: Text(
                  "Transaksi ini telah ${_currentTransaction.status.toLowerCase()}",
                  style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
              
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
              color: isBold ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}