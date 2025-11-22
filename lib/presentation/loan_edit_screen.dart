import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/transaction.dart';
import '../data/model/book.dart';
import '../data/repository/transaction_repository.dart';

class EditLoanScreen extends StatefulWidget {
  final Transaction transaction;
  final Book book;

  const EditLoanScreen({
    super.key,
    required this.transaction,
    required this.book,
  });

  @override
  State<EditLoanScreen> createState() => _EditLoanScreenState();
}

class _EditLoanScreenState extends State<EditLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransactionRepository _repo = TransactionRepository();

  late TextEditingController _dateCtr;
  late TextEditingController _durationCtr;
  late int _totalBiaya;

  @override
  void initState() {
    super.initState();

    _dateCtr = TextEditingController(text: widget.transaction.tglPinjam);
    _durationCtr = TextEditingController(text: widget.transaction.durasiPinjam.toString());
    _totalBiaya = widget.transaction.totalBiaya;
  }

  @override
  void dispose() {
    _dateCtr.dispose();
    _durationCtr.dispose();
    super.dispose();
  }

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

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedTransaction = widget.transaction.copyWith(
          tglPinjam: _dateCtr.text,
          durasiPinjam: int.parse(_durationCtr.text),
          totalBiaya: _totalBiaya,
        );

        await _repo.updateTransaction(updatedTransaction);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perubahan berhasil disimpan!")),
        );

        Navigator.pop(context, updatedTransaction);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e")),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime currentSelection = DateTime.tryParse(_dateCtr.text) ?? today;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentSelection,
      firstDate: today,
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        _dateCtr.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  String _formatRupiah(int number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Edit Peminjaman"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

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
                        borderRadius: BorderRadius.circular(8),
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
                            Text(
                              widget.book.genre,
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.book.judul,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _formatRupiah(widget.book.hargaRental) + " / hari",
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            const Divider(thickness: 10, color: Colors.black12),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Edit Data Sewa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _dateCtr,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Mulai",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.edit),
                      ),
                      onTap: _selectDate, 
                    ),
                    const SizedBox(height: 20),

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
                        if (int.tryParse(val) == null || int.parse(val) < 1) return "Minimal 1 hari";
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Biaya Baru:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            _formatRupiah(_totalBiaya),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
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