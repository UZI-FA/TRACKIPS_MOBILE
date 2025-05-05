import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (_isLoading)
                const CircularProgressIndicator(),
              if (!_isLoading)
                ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
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
                      context.go('/dashboard');
                    } else {
                      setState(() {
                        _error = 'Invalid email or password';
                      });
                    }
                  },
                ),
              const SizedBox(height: 12),
              TextButton(
                child: const Text('Don\'t have an account? Register'),
                onPressed: () {
                  context.go('/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}