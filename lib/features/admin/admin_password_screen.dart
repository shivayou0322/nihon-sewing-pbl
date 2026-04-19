import 'package:flutter/material.dart';
import 'package:nihon_sewing_pbl/l10n/app_localizations.dart';
import '../../data/services/settings_service.dart';

class AdminPasswordScreen extends StatefulWidget {
  const AdminPasswordScreen({super.key});

  @override
  State<AdminPasswordScreen> createState() => _AdminPasswordScreenState();
}

class _AdminPasswordScreenState extends State<AdminPasswordScreen> {
  final SettingsService _settings = SettingsService();

  final _currentAppPwController = TextEditingController();
  final _newAppPwController = TextEditingController();
  final _confirmAppPwController = TextEditingController();
  final _currentAdminCodeController = TextEditingController();
  final _newAdminCodeController = TextEditingController();
  final _confirmAdminCodeController = TextEditingController();

  Future<void> _changeAppPassword() async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentAppPwController.text != _settings.getAppPassword()) { _showMessage(l10n.wrongCurrentPassword); return; }
    if (_newAppPwController.text.isEmpty) { _showMessage(l10n.enterNewPassword); return; }
    if (_newAppPwController.text != _confirmAppPwController.text) { _showMessage(l10n.passwordMismatch); return; }
    await _settings.setAppPassword(_newAppPwController.text);
    _currentAppPwController.clear(); _newAppPwController.clear(); _confirmAppPwController.clear();
    _showMessage(l10n.passwordChanged);
  }

  Future<void> _changeAdminCode() async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentAdminCodeController.text != _settings.getAdminCode()) { _showMessage(l10n.wrongCurrentAdminCode); return; }
    if (_newAdminCodeController.text.isEmpty) { _showMessage(l10n.enterNewAdminCode); return; }
    if (_newAdminCodeController.text != _confirmAdminCodeController.text) { _showMessage(l10n.adminCodeMismatch); return; }
    await _settings.setAdminCode(_newAdminCodeController.text);
    _currentAdminCodeController.clear(); _newAdminCodeController.clear(); _confirmAdminCodeController.clear();
    _showMessage(l10n.adminCodeChanged);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))));
  }

  @override
  void dispose() {
    _currentAppPwController.dispose(); _newAppPwController.dispose(); _confirmAppPwController.dispose();
    _currentAdminCodeController.dispose(); _newAdminCodeController.dispose(); _confirmAdminCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordChangeTitle), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(title: l10n.appPasswordSection, icon: Icons.lock_outline,
                currentController: _currentAppPwController, newController: _newAppPwController, confirmController: _confirmAppPwController,
                onSave: _changeAppPassword, currentLabel: l10n.currentPassword, newLabel: l10n.newPassword, confirmLabel: l10n.confirmPassword),
              const SizedBox(height: 32), const Divider(), const SizedBox(height: 32),
              _buildSection(title: l10n.adminCodeSection, icon: Icons.admin_panel_settings,
                currentController: _currentAdminCodeController, newController: _newAdminCodeController, confirmController: _confirmAdminCodeController,
                onSave: _changeAdminCode, currentLabel: l10n.currentAdminCode, newLabel: l10n.newAdminCode, confirmLabel: l10n.confirmAdminCode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required TextEditingController currentController,
    required TextEditingController newController, required TextEditingController confirmController,
    required VoidCallback onSave, required String currentLabel, required String newLabel, required String confirmLabel}) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [Icon(icon, size: 28), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))]),
      const SizedBox(height: 16),
      _buildPasswordField(currentController, currentLabel), const SizedBox(height: 12),
      _buildPasswordField(newController, newLabel), const SizedBox(height: 12),
      _buildPasswordField(confirmController, confirmLabel), const SizedBox(height: 16),
      ElevatedButton(onPressed: onSave, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: Text(l10n.saveChanges)),
    ]);
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(controller: controller, obscureText: true, style: const TextStyle(fontSize: 20), keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.all(16)));
  }
}
