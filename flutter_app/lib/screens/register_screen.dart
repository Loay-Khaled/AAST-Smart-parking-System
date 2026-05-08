import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    final result = await AuthService.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
      _plateCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.local_parking, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                const SizedBox(height: 8),
                const Text('Join AAST Smart Parking', style: TextStyle(fontSize: 15, color: AppColors.muted)),
                const SizedBox(height: 28),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 14))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  controller: _nameCtrl,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  hint: 'At least 6 characters',
                  prefixIcon: Icons.lock_outlined,
                  controller: _passCtrl,
                  isPassword: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Car Plate Number',
                  hint: 'e.g. ABC 1234',
                  prefixIcon: Icons.directions_car_outlined,
                  controller: _plateCtrl,
                ),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _register, child: const Text('Create Account')),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: AppColors.muted),
                      children: [TextSpan(text: 'Sign in', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))],
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
