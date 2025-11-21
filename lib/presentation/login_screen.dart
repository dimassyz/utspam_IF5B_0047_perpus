import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Wajib import ini
import '../data/repository/auth_repository.dart'; // Import Repository
import '../data/model/user.dart'; // Import Model
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtr = TextEditingController(); 
  final _passwordCtr = TextEditingController();
  bool isObscure = true;
  final AuthRepository _authRepository = AuthRepository();

  // Fungsi login
  void _performLogin() async {
    if (_formKey.currentState!.validate()) {

      final String input = _identifierCtr.text;
      final String pass = _passwordCtr.text;
      User? user = await _authRepository.loginUser(input, pass);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user.id!); 
        await prefs.setString('userName', user.namaLengkap);
        await prefs.setBool('isLoggedIn', true);

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Gagal! Email/NIK atau Password salah.'),
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
        child: Center( // Bungkus SingleChild dengan Center biar rapi
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logobuku.png',
                  width: 300,
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  "Login ke akun anda",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Silahkan gunakan NIK / Email untuk login",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      // email/nik
                      TextFormField(
                        controller: _identifierCtr,
                        decoration: InputDecoration(
                          labelText: 'Email / NIK',
                          hintText: 'Masukkan Email atau NIK anda',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: Icon(Icons.person_outline),
                        ),

                        // validasi email/nik
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email atau NIK wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // password
                      TextFormField(
                        controller: _passwordCtr,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),

                        // validasi password
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      // TOMBOL LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _performLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
                
                // tombol registrasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}