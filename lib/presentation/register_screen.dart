import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart'; 
import '../data/model/user.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtr = TextEditingController();
  final _nikCtr = TextEditingController(); 
  final _usernameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _alamatCtr = TextEditingController();
  final _telpCtr = TextEditingController();
  final _passCtr = TextEditingController();

  bool passwordInvisible = true;
  final AuthRepository _authRepository = AuthRepository();

  // Fungsi registrasi
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newUser = User(
          id: null,
          namaLengkap: _namaCtr.text,
          nik: _nikCtr.text,
          email: _emailCtr.text,
          alamat: _alamatCtr.text,
          telp: _telpCtr.text,
          username: _usernameCtr.text,
          password: _passCtr.text,
        );

        await _authRepository.registerUser(newUser);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Berhasil! Silakan Login.'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: Username atau Email mungkin sudah terdaftar.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}