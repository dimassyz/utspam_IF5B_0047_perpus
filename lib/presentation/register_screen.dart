import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
       backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logobuku.png',
                width: 150,
                height: 100,
                ),
              const SizedBox(height: 10),
              const Text(
                'Formulir Pendaftaran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Lengkapi data diri untuk mendaftar',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [

                    // form nama
                    TextFormField(
                      controller: _namaCtr,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),

                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // form nik
                    TextFormField(
                      controller: _nikCtr,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'NIK',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.badge_sharp),
                      ),

                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // form username
                    TextFormField(
                      controller: _usernameCtr,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                      ),

                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // form email
                    TextFormField(
                      controller: _emailCtr,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Wajib diisi';
                        if (!value.endsWith('@gmail.com')) {
                          return 'Email harus berformat @gmail.com';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // form alamat
                    TextFormField(
                      controller: _alamatCtr,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.location_on),
                      ),

                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // form nomor telpon
                    TextFormField(
                      controller: _telpCtr,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.vertical()
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),

                      validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // form password
                    TextFormField(
                      controller: _passCtr,
                      obscureText: passwordInvisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.vertical()),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(passwordInvisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => passwordInvisible = !passwordInvisible),
                        ),
                      ),

                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Wajib diisi';
                        if (val.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // tombol daftar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('DAFTAR', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // tombol kembali ke login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login disini",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}