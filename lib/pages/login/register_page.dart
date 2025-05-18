import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Color.fromARGB(255, 100, 69, 255)),
              const SizedBox(height: 16),
              Text(
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new account',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              _buildInputField(Icons.person, "Full Name", _nameController),
              const SizedBox(height: 16),
              _buildInputField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 16),
              _buildInputField(Icons.lock_outline, "Password", _passwordController, isPassword: true),
              const SizedBox(height: 16),
              _buildInputField(Icons.lock_outline, "Confirm Password", _confirmController, isPassword: true),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator(),
              if (!_isLoading)
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text != _confirmController.text) {
                      setState(() {
                        _error = 'Passwords do not match';
                      });
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    bool success = await authProvider.register(
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    if (success) {
                      context.go('/dashboard');
                    } else {
                      setState(() {
                        _error = 'Registration failed';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 69, 255),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: 
                          [Color.fromARGB(255, 100, 69, 255),Color.fromARGB(255, 61, 32, 203)]
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Container(
                      width: 250,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("Register", style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
                    )
                  ),
                ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text(
                  "Already have an account? Login",
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInputField(IconData icon, String hint, TextEditingController _controller,{bool isPassword = false}) {
    return TextField(
      controller: _controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F4FA),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFF9CA3AF),
        ),
      )
    );
  }
}

