import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pertemuan1/loginScreen.dart';
import 'package:flutter_pertemuan1/widget/fieldCustom.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> _daftar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 1. Buat akun di Firebase Authentication
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      // 2. Simpan data tambahan (nama, dll) ke Firestore collection 'users'
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'nama': namaController.text.trim(),
        'email': emailController.text.trim(),
        'instagram': '', // bisa diisi nanti dari halaman Profile
        'fotoProfil': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil, silakan login')),
      );

      // 3. Arahkan ke halaman Login (bukan langsung ke Home)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Pendaftaran gagal, silakan coba lagi';
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar, silakan login';
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah, minimal 6 karakter';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  height: 150,
                  width: 150,
                ),
                textFieldCustom('Masukkan Nama', namaController),
                textFieldCustom('Masukkan Email', emailController),
                textFieldCustom('Masukkan Password', passController,
                    obscureText: true),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _daftar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Daftar'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginscreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Apakah sudah punya akun? ',
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}