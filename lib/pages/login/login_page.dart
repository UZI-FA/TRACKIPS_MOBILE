import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                'Welcome Back',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue to TrackIPS',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              _buildInputField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 16),
              _buildInputField(Icons.lock_outline, "Password", _passwordController,isPassword: true),
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
                  onPressed: () async{
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    bool success = await authProvider.login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    if (success) {
                      //doesnt work, use initialLocation in routing.dart instead
                      context.go('/dashboard');
                    } else {
                      setState(() {
                        _error = 'Invalid email or password';
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
                      child: Text("Login", style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
                    )
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                spacing: 20,
                children: [
                  Expanded(child: Divider(height: 20, thickness: 1, indent: 20, endIndent: 0, color: Colors.grey[350]),),
                  
                  Text('Or continue with'),
                  Expanded(child: Divider(height: 20, thickness: 1, indent: 20, endIndent: 0, color: Colors.grey[350]),),
                  
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 100, 69, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: 
                        [Color.fromARGB(255, 250, 250, 250),Color.fromARGB(255, 255, 243, 243)]
                      ),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Container(
                    width: 250,
                    height: 40,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google button
                        _SocialIconButton(
                          // color: const Color(0xFFDB4437),
                          onPressed: () {},
                          semanticLabel: 'Sign in with Google',
                          customIcon: 'https://img.icons8.com/?size=100&id=V5cGWnc9R4xj&format=png&color=000000',
                        ),
                        Text("Sign in with Google", style: GoogleFonts.poppins(fontSize: 16,color: Colors.black87)),
                      ],
                    ),
                  )
                ),
                // child: Text("Login", style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // Google button
              //     _SocialIconButton(
              //       color: const Color(0xFFDB4437),
              //       onPressed: () {},
              //       semanticLabel: 'Log in with Google',
              //       customIcon: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png?20230822192911',
              //     ),

              //   ],
              // ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text(
                  "Don't have an account? Register",
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint,TextEditingController _controller, {bool isPassword = false}) {
    return TextField(
      controller: _controller,
      autocorrect: false,
      autofocus: true,
      textInputAction: TextInputAction.next,
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

class _SocialIconButton extends StatelessWidget {
  final IconData? icon;
  // final Color color;
  final VoidCallback onPressed;
  final String semanticLabel;
  final String? customIcon;

  const _SocialIconButton({
    this.icon,
    // required this.color,
    required this.onPressed,
    required this.semanticLabel,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (customIcon != null) {
      // Use Google logo from network or custom icon
      iconWidget = Image.network(
        customIcon!,
        width: 20,
        height: 20,
        // color: color,
        semanticLabel: semanticLabel,
      );
    } else if(icon == null) {
      iconWidget = Icon(
        Icons.do_not_disturb_alt_outlined,
        // color: color,
        size: 18,
        semanticLabel: semanticLabel,
      );
    } else{
      iconWidget = Icon(
        icon,
        // color: color,
        size: 18,
        semanticLabel: semanticLabel,
      );
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          width: 32,
          height: 32,
          // decoration: BoxDecoration(
          //   border: Border.all(color: const Color(0xFFD1D5DB)),
          //   shape: BoxShape.circle,
          // ),
          alignment: Alignment.center,
          child: iconWidget,
        ),
      ),
    );
  }
}