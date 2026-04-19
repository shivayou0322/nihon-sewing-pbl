import 'package:flutter/material.dart';
import 'package:nihon_sewing_pbl/l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/settings_service.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  String _password = '';
  String _adminCode = '';
  bool _isAdminCodeStep = false;
  String? _errorMessage;
  final SettingsService _settings = SettingsService();

  void _onKeyTap(String value) {
    setState(() {
      if (_isAdminCodeStep) {
        if (_adminCode.length < 8) { _adminCode += value; _errorMessage = null; }
      } else {
        if (_password.length < 8) { _password += value; _errorMessage = null; }
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (_isAdminCodeStep) {
        if (_adminCode.isNotEmpty) { _adminCode = _adminCode.substring(0, _adminCode.length - 1); _errorMessage = null; }
      } else {
        if (_password.isNotEmpty) { _password = _password.substring(0, _password.length - 1); _errorMessage = null; }
      }
    });
  }

  void _onNext() {
    final l10n = AppLocalizations.of(context)!;
    if (!_isAdminCodeStep) {
      if (_password == _settings.getAppPassword()) {
        setState(() { _isAdminCodeStep = true; _errorMessage = null; });
      } else {
        setState(() { _errorMessage = l10n.loginError; _password = ''; });
      }
    } else {
      if (_adminCode == _settings.getAdminCode()) {
        Navigator.pushReplacementNamed(context, '/admin-menu');
      } else {
        setState(() { _errorMessage = l10n.adminCodeError; _adminCode = ''; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentInput = _isAdminCodeStep ? _adminCode : _password;
    final title = _isAdminCodeStep ? l10n.adminAuthStep2 : l10n.adminAuthStep1;
    final stepText = l10n.stepOf(_isAdminCodeStep ? '2' : '1', '2');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.adminAuthTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isAdminCodeStep) {
              setState(() { _isAdminCodeStep = false; _adminCode = ''; _errorMessage = null; });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(stepText, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                const SizedBox(height: 8),
                Icon(_isAdminCodeStep ? Icons.admin_panel_settings : Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),
                Text(title, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _errorMessage != null ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outline, width: 2),
                  ),
                  child: Text(currentInput.isEmpty ? '' : '● ' * currentInput.length, style: const TextStyle(fontSize: 32, letterSpacing: 8), textAlign: TextAlign.center),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage!, style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 32),
                _buildKeypad(),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: currentInput.isNotEmpty ? _onNext : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary, padding: const EdgeInsets.symmetric(vertical: 20)),
                      child: Text(_isAdminCodeStep ? l10n.loginButton : l10n.next),
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

  Widget _buildKeypad() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var col = 1; col <= 3; col++) _buildKeyButton('${row * 3 + col}'),
              ]),
            ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: AppConstants.keypadButtonSize + 16, height: AppConstants.keypadButtonSize),
            _buildKeyButton('0'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: AppConstants.keypadButtonSize, height: AppConstants.keypadButtonSize,
                child: IconButton.filled(onPressed: _onDelete, icon: const Icon(Icons.backspace_outlined, size: 28),
                  style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.errorContainer, foregroundColor: Theme.of(context).colorScheme.onErrorContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(width: AppConstants.keypadButtonSize, height: AppConstants.keypadButtonSize,
        child: ElevatedButton(onPressed: () => _onKeyTap(number),
          style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: Text(number, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))),
    );
  }
}
