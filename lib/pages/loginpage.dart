import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirut_final_app/component/bottombar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
        );

        Navigator.pushReplacementNamed(context, '/admin'); // นำไปหน้า Homepage
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'ไม่พบผู้ใช้นี้';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'รหัสผ่านไม่ถูกต้อง';
        } else {
          errorMessage = 'เกิดข้อผิดพลาด: ${e.message}';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.email),
                    hintText: 'กรุณาใส่ Email',
                    labelText: 'nirut@gmail.com',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณาใส่ email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.lock),
                    hintText: 'กรุณาใส่รหัสผ่าน',
                    labelText: '123456',
                    suffixIcon: GestureDetector(
                      onLongPress: () =>
                          setState(() => _obscurePassword = false),
                      onLongPressUp: () =>
                          setState(() => _obscurePassword = true),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'กรุณาใส่ password'
                      : null,
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('เข้าสู่ระบบ'),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const SignupPage()),
                //     );
                //   },
                //   child: const Text('สมัครสมาชิก'),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
