import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _inputPassword = '';
  String? _errorMessage;

  void _onKeyTap(String value) {
    if (_inputPassword.length < 8) {
      setState(() {
        _inputPassword += value;
        _errorMessage = null;
      });
    }
  }

  void _onDelete() {
    if (_inputPassword.isNotEmpty) {
      setState(() {
        _inputPassword = _inputPassword.substring(0, _inputPassword.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _onLogin() {
    if (_inputPassword == AppConstants.appPassword) {
      Navigator.pushReplacementNamed(context, '/search');
    } else {
      setState(() {
        _errorMessage = 'パスワードが正しくありません';
        _inputPassword = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'パスワードを入力してください',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _errorMessage != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _inputPassword.isEmpty ? '' : '● ' * _inputPassword.length,
                    style: const TextStyle(fontSize: 32, letterSpacing: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                _buildKeypad(),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ElevatedButton(
                    onPressed: _inputPassword.isNotEmpty ? _onLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: const Text('ログイン'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var col = 1; col <= 3; col++)
                    _buildKeyButton('${row * 3 + col}'),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppConstants.keypadButtonSize + 16,
                height: AppConstants.keypadButtonSize,
              ),
              _buildKeyButton('0'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: AppConstants.keypadButtonSize,
                  height: AppConstants.keypadButtonSize,
                  child: IconButton.filled(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace_outlined, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: AppConstants.keypadButtonSize,
        height: AppConstants.keypadButtonSize,
        child: ElevatedButton(
          onPressed: () => _onKeyTap(number),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
