import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; 
import '../data/model/book.dart';
import '../data/model/transaction.dart';
import '../data/repository/transaction_repository.dart';
import 'history_screen.dart';

class LoanFormScreen extends StatefulWidget {
  final Book book; 

  const LoanFormScreen({super.key, required this.book});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _durationCtr = TextEditingController();
  final _dateCtr = TextEditingController();
  
  final TransactionRepository _transactionRepo = TransactionRepository();
  
  int _totalBiaya = 0;
  String _namaPeminjam = ""; 
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // tanggal saat pinjam
    _dateCtr.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // fungsi untuk mengambil data nama dan id user 
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
      _namaPeminjam = prefs.getString('userName') ?? "User"; 
    });
  }

  // menghitung total biaya * hari
  void _hitungTotal() {
    if (_durationCtr.text.isEmpty) {
      setState(() => _totalBiaya = 0);
      return;
    }
    int durasi = int.tryParse(_durationCtr.text) ?? 0;
    setState(() {
      _totalBiaya = durasi * widget.book.hargaRental; 
    });
  }

  // eksekusi transaksi 
  void _submitLoan() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sesi habis, silakan login ulang")));
        return;
      }

      try {
        final newLoan = Transaction(
          userId: _userId!,
          bookId: widget.book.id!,
          tglPinjam: _dateCtr.text,
          durasiPinjam: int.parse(_durationCtr.text),
          totalBiaya: _totalBiaya,
          status: 'AKTIF', 
        );

        await _transactionRepo.insertTransaction(newLoan);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Peminjaman Berhasil Disimpan!"),
            backgroundColor: Colors.green,
          ),
        );

          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Hfungsi helper format rp
  String _formatRupiah(int number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  // fungsi date picker
  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now, 
      firstDate: now,
      lastDate: DateTime(now.year + 1), // max setahun untuk pemilihan hari 
    );

    if (pickedDate != null) {
      setState(() {
        _dateCtr.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Peminjaman"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // detail buku
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          widget.book.coverPath,
                          width: 90, height: 130, fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 90, height: 130, color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.book.genre, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(widget.book.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(_formatRupiah(widget.book.hargaRental) + " / hari", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Sinopsis:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.book.sinopsis, style: const TextStyle(color: Colors.black87, height: 1.5), textAlign: TextAlign.justify),
                ],
              ),
            ),
            
            const Divider(thickness: 8, color: Colors.black12),

            // formulir input data
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // nama peminjam
                    TextFormField(
                      key: ValueKey(_namaPeminjam), 
                      initialValue: _namaPeminjam,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Nama Peminjam",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // tanggal
                    TextFormField(
                      controller: _dateCtr,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Mulai Pinjam",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),

                    // durasi pinjam
                    TextFormField(
                      controller: _durationCtr,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Lama Pinjam (Hari)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                        suffixText: "Hari",
                      ),
                      onChanged: (val) => _hitungTotal(),
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Wajib diisi";
                        if (int.tryParse(val) == null || int.parse(val) < 1) return "Minimal peminjaman adalah 1 hari";
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // total biaya
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Biaya:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            _formatRupiah(_totalBiaya),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitLoan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("KONFIRMASI PEMINJAMAN", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}